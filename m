Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:63440 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003AbZJDU5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2009 16:57:36 -0400
Message-ID: <4AC90C17.70103@freemail.hu>
Date: Sun, 04 Oct 2009 22:56:55 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	Kyle Guinn <elyk03@gmail.com>,
	Theodore Kilgore <kilgota@auburn.edu>,
	ltp-list@lists.sourceforge.net
CC: V4L Mailing List <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pac_common: redesign function for finding Start Of Frame
References: <4AC90BBF.9040803@freemail.hu>
In-Reply-To: <4AC90BBF.9040803@freemail.hu>
Content-Type: multipart/mixed;
 boundary="------------010600030802050504020505"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010600030802050504020505
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

I wrote a simple test for pac_find_sof(). I implemented a user-space test
which takes the implementation from the source file and calls it directly.
You can find the source code of the test attached.

The test results for the pac_find_sof() implementation in the Linux kernel
2.6.32-rc1 is the following:

Test case 1: exact match
PDEBUG: SOF found, bytes to analyze: 5. Frame starts at byte #5
PASSED

Test case 2: offset 1
PDEBUG: SOF found, bytes to analyze: 6. Frame starts at byte #6
PASSED

Test case 3: offset 1, first byte may be misleading
FAILED

Test case 4: offset 2, first two bytes may be misleading
PDEBUG: SOF found, bytes to analyze: 7. Frame starts at byte #7
PASSED

Test case 5: offset 3, first three bytes may be misleading
FAILED

Test case 6: offset 4, first four bytes may be misleading
FAILED

Test case 7: pattern starts at end of packet and continues in the next one
PDEBUG: SOF found, bytes to analyze: 1. Frame starts at byte #1
PASSED

Test case 8: splited pattern, with misleading first byte
FAILED

Test case 9: splited pattern, with misleading first three bytes
FAILED

Test case 10: no match, extra byte at offset 1
PASSED

Test case 11: no match, extra byte at offset 2
PASSED

Test case 12: no match, extra byte at offset 3
PASSED

Test case 13: no match, extra byte at offset 4
PASSED

I also executed the test with the patched pac_find_sof() implementation
and that one passes all these test cases.

Regards,

	Márton Németh

Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The original implementation of pac_find_sof() does not always find
> the Start Of Frame (SOF) marker. Replace it with a state machine
> based design.
> 
> The change was tested with Labtec Webcam 2200.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> --- linux-2.6.32-rc1.orig/drivers/media/video/gspca/pac_common.h	2009-09-10 00:13:59.000000000 +0200
> +++ linux-2.6.32-rc1/drivers/media/video/gspca/pac_common.h	2009-10-04 21:49:19.000000000 +0200
> @@ -33,6 +33,45 @@
>  static const unsigned char pac_sof_marker[5] =
>  		{ 0xff, 0xff, 0x00, 0xff, 0x96 };
> 
> +/*
> +   The following state machine finds the SOF marker sequence
> +   0xff, 0xff, 0x00, 0xff, 0x96 in a byte stream.
> +
> +	   +----------+
> +	   | 0: START |<---------------\
> +	   +----------+<-\             |
> +	     |       \---/otherwise    |
> +	     v 0xff                    |
> +	   +----------+ otherwise      |
> +	   |     1    |--------------->*
> +	   |          |                ^
> +	   +----------+                |
> +	     |                         |
> +	     v 0xff                    |
> +	   +----------+<-\0xff         |
> +	/->|          |--/             |
> +	|  |     2    |--------------->*
> +	|  |          | otherwise      ^
> +	|  +----------+                |
> +	|    |                         |
> +	|    v 0x00                    |
> +	|  +----------+                |
> +	|  |     3    |                |
> +	|  |          |--------------->*
> +	|  +----------+ otherwise      ^
> +	|    |                         |
> +   0xff |    v 0xff                    |
> +	|  +----------+                |
> +	\--|     4    |                |
> +	   |          |----------------/
> +	   +----------+ otherwise
> +	     |
> +	     v 0x96
> +	   +----------+
> +	   |  FOUND   |
> +	   +----------+
> +*/
> +
>  static unsigned char *pac_find_sof(struct gspca_dev *gspca_dev,
>  					unsigned char *m, int len)
>  {
> @@ -41,17 +80,54 @@ static unsigned char *pac_find_sof(struc
> 
>  	/* Search for the SOF marker (fixed part) in the header */
>  	for (i = 0; i < len; i++) {
> -		if (m[i] == pac_sof_marker[sd->sof_read]) {
> -			sd->sof_read++;
> -			if (sd->sof_read == sizeof(pac_sof_marker)) {
> +		switch (sd->sof_read) {
> +		case 0:
> +			if (m[i] == 0xff)
> +				sd->sof_read = 1;
> +			break;
> +		case 1:
> +			if (m[i] == 0xff)
> +				sd->sof_read = 2;
> +			else
> +				sd->sof_read = 0;
> +			break;
> +		case 2:
> +			switch (m[i]) {
> +			case 0x00:
> +				sd->sof_read = 3;
> +				break;
> +			case 0xff:
> +				/* stay in this state */
> +				break;
> +			default:
> +				sd->sof_read = 0;
> +			}
> +			break;
> +		case 3:
> +			if (m[i] == 0xff)
> +				sd->sof_read = 4;
> +			else
> +				sd->sof_read = 0;
> +			break;
> +		case 4:
> +			switch (m[i]) {
> +			case 0x96:
> +				/* Pattern found */
>  				PDEBUG(D_FRAM,
>  					"SOF found, bytes to analyze: %u."
>  					" Frame starts at byte #%u",
>  					len, i + 1);
>  				sd->sof_read = 0;
>  				return m + i + 1;
> +				break;
> +			case 0xff:
> +				sd->sof_read = 2;
> +				break;
> +			default:
> +				sd->sof_read = 0;
>  			}
> -		} else {
> +			break;
> +		default:
>  			sd->sof_read = 0;
>  		}
>  	}
> 


--------------010600030802050504020505
Content-Type: text/x-csrc;
 name="test_pac_find_sof.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="test_pac_find_sof.c"


/*
  Test the function pac_find_sof() from file
  linux/drivers/media/video/gspca/pac_common.h

  Test based on Linux kernel 2.6.32-rc1
  Written by Márton Németh <nm127@freemail.hu>, 4 Oct 2009
  Released under GPL
*/

#include <stdio.h>

struct sd {
	unsigned int sof_read;
};

struct gspca_dev {
    struct sd* sd;
};

#define PDEBUG(level, fmt, args...) \
	do {\
		printf("PDEBUG: " fmt "\n", ## args); \
	} while (0)

#include "pac_common.h"

int tc1() {
	static unsigned char test[] = { 0xff, 0xff, 0x00, 0xff, 0x96 };
	unsigned char* p;
	struct sd sd;
	int result = 0;

	printf("Test case 1: exact match\n");
	sd.sof_read = 0;
	p = pac_find_sof((struct gspca_dev*)&sd, test, sizeof(test));
	if (p == &test[5]) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}

int tc2() {
	static unsigned char test[] = { 0x00, 0xff, 0xff, 0x00, 0xff, 0x96 };
	unsigned char* p;
	struct sd sd;
	int result = 0;

	printf("Test case 2: offset 1\n");
	sd.sof_read = 0;
	p = pac_find_sof((struct gspca_dev*)&sd, test, sizeof(test));
	if (p == &test[6]) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}

int tc3() {
	static unsigned char test[] = { 0xff, 0xff, 0xff, 0x00, 0xff, 0x96 };
	unsigned char* p;
	struct sd sd;
	int result = 0;

	printf("Test case 3: offset 1, first byte may be misleading\n");
	sd.sof_read = 0;
	p = pac_find_sof((struct gspca_dev*)&sd, test, sizeof(test));
	if (p == &test[6]) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}

int tc4() {
	static unsigned char test[] = { 0xff, 0x00, 0xff, 0xff, 0x00, 0xff, 0x96 };
	unsigned char* p;
	struct sd sd;
	int result = 0;

	printf("Test case 4: offset 2, first two bytes may be misleading\n");
	sd.sof_read = 0;
	p = pac_find_sof((struct gspca_dev*)&sd, test, sizeof(test));
	if (p == &test[7]) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}

int tc5() {
	static unsigned char test[] = { 0xff, 0xff, 0x00, 0xff, 0xff, 0x00, 0xff, 0x96 };
	unsigned char* p;
	struct sd sd;
	int result = 0;

	printf("Test case 5: offset 3, first three bytes may be misleading\n");
	sd.sof_read = 0;
	p = pac_find_sof((struct gspca_dev*)&sd, test, sizeof(test));
	if (p == &test[8]) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}

int tc6() {
	static unsigned char test[] = { 0xff, 0xff, 0x00, 0xff, 0xff, 0xff, 0x00, 0xff, 0x96 };
	unsigned char* p;
	struct sd sd;
	int result = 0;

	printf("Test case 6: offset 4, first four bytes may be misleading\n");
	sd.sof_read = 0;
	p = pac_find_sof((struct gspca_dev*)&sd, test, sizeof(test));
	if (p == &test[9]) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}

int tc7() {
	static unsigned char test1[] = { 0xff, 0xff, 0x00, 0xff };
	static unsigned char test2[] = { 0x96 };
	unsigned char* p1;
	unsigned char* p2;
	struct sd sd;
	int result = 0;

	printf("Test case 7: pattern starts at end of packet and continues in the next one\n");
	sd.sof_read = 0;
	p1 = pac_find_sof((struct gspca_dev*)&sd, test1, sizeof(test1));
	p2 = pac_find_sof((struct gspca_dev*)&sd, test2, sizeof(test2));
	if (p1 == NULL && p2 == &test2[1]) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}

int tc8() {
	static unsigned char test1[] = { 0xff, 0xff, 0xff, 0x00, 0xff };
	static unsigned char test2[] = { 0x96 };
	unsigned char* p1;
	unsigned char* p2;
	struct sd sd;
	int result = 0;

	printf("Test case 8: splited pattern, with misleading first byte\n");
	sd.sof_read = 0;
	p1 = pac_find_sof((struct gspca_dev*)&sd, test1, sizeof(test1));
	p2 = pac_find_sof((struct gspca_dev*)&sd, test2, sizeof(test2));
	if (p1 == NULL && p2 == &test2[1]) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}

int tc9() {
	static unsigned char test1[] = { 0xff, 0xff, 0x00, 0xff, 0xff, 0x00, 0xff };
	static unsigned char test2[] = { 0x96 };
	unsigned char* p1;
	unsigned char* p2;
	struct sd sd;
	int result = 0;

	printf("Test case 9: splited pattern, with misleading first three bytes\n");
	sd.sof_read = 0;
	p1 = pac_find_sof((struct gspca_dev*)&sd, test1, sizeof(test1));
	p2 = pac_find_sof((struct gspca_dev*)&sd, test2, sizeof(test2));
	if (p1 == NULL && p2 == &test2[1]) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}

int tc10() {
	static unsigned char test[] = { 0xff, 0xaa, 0xff, 0x00, 0xff, 0x96 };
	unsigned char* p;
	struct sd sd;
	int result = 0;

	printf("Test case 10: no match, extra byte at offset 1\n");
	sd.sof_read = 0;
	p = pac_find_sof((struct gspca_dev*)&sd, test, sizeof(test));
	if (p == NULL) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}

int tc11() {
	static unsigned char test[] = { 0xff, 0xff, 0xaa, 0x00, 0xff, 0x96 };
	unsigned char* p;
	struct sd sd;
	int result = 0;

	printf("Test case 11: no match, extra byte at offset 2\n");
	sd.sof_read = 0;
	p = pac_find_sof((struct gspca_dev*)&sd, test, sizeof(test));
	if (p == NULL) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}

int tc12() {
	static unsigned char test[] = { 0xff, 0xff, 0x00, 0xaa, 0xff, 0x96 };
	unsigned char* p;
	struct sd sd;
	int result = 0;

	printf("Test case 12: no match, extra byte at offset 3\n");
	sd.sof_read = 0;
	p = pac_find_sof((struct gspca_dev*)&sd, test, sizeof(test));
	if (p == NULL) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}

int tc13() {
	static unsigned char test[] = { 0xff, 0xff, 0x00, 0xff, 0xaa, 0x96 };
	unsigned char* p;
	struct sd sd;
	int result = 0;

	printf("Test case 13: no match, extra byte at offset 4\n");
	sd.sof_read = 0;
	p = pac_find_sof((struct gspca_dev*)&sd, test, sizeof(test));
	if (p == NULL) {
		printf("PASSED\n");
	} else {
		printf("FAILED\n");
		result = 1;
	}
	printf("\n");

	return result;
}


int main() {
	int result = 0;

	result += tc1();
	result += tc2();
	result += tc3();
	result += tc4();
	result += tc5();
	result += tc6();
	result += tc7();
	result += tc8();
	result += tc9();
	result += tc10();
	result += tc11();
	result += tc12();
	result += tc13();

	return result;
}

--------------010600030802050504020505--

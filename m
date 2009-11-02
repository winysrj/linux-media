Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:54545 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbZKBRnk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 12:43:40 -0500
Message-ID: <4AEF1A44.5000502@freemail.hu>
Date: Mon, 02 Nov 2009 18:43:32 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: Re: [PATCH 1/3] gspca pac7302/pac7311: simplify pac_find_sof
References: <4AEE04CB.5060802@freemail.hu> <alpine.LNX.2.00.0911012112421.7702@banach.math.auburn.edu> <4AEE720A.50101@freemail.hu> <alpine.LNX.2.00.0911021016100.8213@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0911021016100.8213@banach.math.auburn.edu>
Content-Type: multipart/mixed;
 boundary="------------060308050205070304060301"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060308050205070304060301
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit

Theodore Kilgore írta:
> 
> On Mon, 2 Nov 2009, Németh Márton wrote:
> 
>> Theodore Kilgore wrote:
>>> On Sun, 1 Nov 2009, Németh Márton wrote:
>>>> Remove struct sd dependency from pac_find_sof() function implementation.
>>>> This step prepares separation of pac7302 and pac7311 specific parts of
>>>> struct sd.
>>> [...]
>>> But here is the point. The sn9c2028 cameras have a structure which seems
>>> similar to the mr97310a cameras. They use a similar decompression
>>> algorithm. They have a similar frame header. Specifically, the sn9c2028
>>> frame header starts with the five bytes
>>>
>>>                  0xff, 0xff, 0x00, 0xc4, 0xc4
>>>
>>> whereas the pac_common frame header starts with the five bytes
>>>
>>>                  0xff, 0xff, 0x00, 0xff, 0x96
>>>
>>> Right now, for my own use, I have written a file sn9c2028.h which
>>> essentially duplicates the functionality of pac_common.h and contains a
>>> function which searches for the sn9c2028 SOF marker instead of searching
>>> for the pac SOF marker. Is this necessarily the good, permanent solution?
>>> I am not so sure about that.
>> I think the pac_find_sof() is a special case. To find a SOF sequence in
>> a bigger buffer in general needs to first analyze the SOF sequence for
>> repeated bytes. If there are repeated bytes the search have to be
>> continued in a different way, see the state machine currently in the
>> pac_common.h. To find the sn9c2028 frame header a different state machine
>> is needed. It might be possible to implement a search function which
>> can find any SOF sequence but I am afraid that this algorithm would be
>> too complicated because of the search string analysis.
> 
> Well, I do not really know enough about this to be able to say something 
> authoritative, but:
> 
> 1. There is an obvious limitation on the length of the SOF marker. If it 
> is agreed upon that the SOF marker is 5 bytes or less, then it ought not 
> to be so terrible a thing to do. Namely, your state machine should accept 
> an input, consisting of a pointer to the proper SOF marker and use that 
> one instead of what is "hard wired" in your code. So, for example,
> 
>                  switch (sd->sof_read) {
>                  case 0:
>                          if (m[i] == 0xff)
>                                  sd->sof_read = 1;
>                          break;
>                  case 1:
>                          if (m[i] == 0xff)
>                                  sd->sof_read = 2;
>                          else
>                                  sd->sof_read = 0;
>                          break;
>  			(and so on)
> 
> could read instead as
> 
>                  switch (sd->sof_read) {
>                  case 0:
>                          if (m[i] == sof_marker[0])
>                                  sd->sof_read = 1;
>                          break;
>                  case 1:
>                          if (m[i] == sof_marker[1])
>                                  sd->sof_read = 2;
>                          else
>                                  sd->sof_read = 0;
>                          break;
>  			(and so on)
> 
> 
> The problem would come if the SOF marker were six bytes long instead. The 
> way to solve that would be to figure out what is the longest SOF marker 
> that one wants to deal with, beforehand. I am not sure what is the 
> prevailing number of bytes in such an SOF marker, or the maximum number. 
> But it would be possible to prescribe some reasonable maximum number 
> and take that into account, I think.

I am afraid you missed an important point: the state machine depends on the
*contents* of the SOF marker:

>From pac_common.h:

   The following state machine finds the SOF marker sequence
   0xff, 0xff, 0x00, 0xff, 0x96 in a byte stream.

           +----------+
           | 0: START |<---------------\
           +----------+<-\             |
             |       \---/otherwise    |
             v 0xff                    |
           +----------+ otherwise      |
           |     1    |--------------->*
           |          |                ^
           +----------+                |
             |                         |
             v 0xff                    |
           +----------+<-\0xff         |
        /->|          |--/             |
        |  |     2    |--------------->*
        |  |          | otherwise      ^
        |  +----------+                |
        |    |                         |
        |    v 0x00                    |
        |  +----------+                |
        |  |     3    |                |
        |  |          |--------------->*
        |  +----------+ otherwise      ^
        |    |                         |
   0xff |    v 0xff                    |
        |  +----------+                |
        \--|     4    |                |
           |          |----------------/
           +----------+ otherwise
             |
             v 0x96
           +----------+
           |  FOUND   |
           +----------+

Please have a closer look of the transients 2->2 and
4->2. They heavily depend on the 0xff bytes found in the
SOF marker. You might also want to have a look at the attached
test cases to see why the state machine is necessary.

Regards,

	Márton Németh



--------------060308050205070304060301
Content-Type: text/x-csrc;
 name="test_pac_find_sof.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="test_pac_find_sof.c"


/*
  Test the function pac_find_sof() from file
  linux/drivers/media/video/gspca/pac_common.h

  Test based on Linux kernel 2.6.32-rc1
  Written by MÃ¡rton NÃ©meth <nm127@freemail.hu>, 4 Oct 2009
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

--------------060308050205070304060301--

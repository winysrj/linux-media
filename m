Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:49195 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab0A0VmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 16:42:09 -0500
Message-ID: <4B60B32A.5090806@freemail.hu>
Date: Wed, 27 Jan 2010 22:42:02 +0100
From: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera: match signedness of soc_camera_limit_side()
References: <4B5AFD11.6000907@freemail.hu> <Pine.LNX.4.64.1001271645440.5073@axis700.grange> <4B6081D4.5070501@freemail.hu> <Pine.LNX.4.64.1001271915400.5073@axis700.grange> <4B609AD4.605@freemail.hu> <Pine.LNX.4.64.1001272109470.5073@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1001272109470.5073@axis700.grange>
Content-Type: multipart/mixed;
 boundary="------------050906040806050800030403"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050906040806050800030403
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Guennadi Liakhovetski wrote:
> You didn't reply to my most important objection:
> 
> On Wed, 27 Jan 2010, Németh Márton wrote:
> 
>> diff -r 31eaa9423f98 linux/include/media/soc_camera.h
>> --- a/linux/include/media/soc_camera.h	Mon Jan 25 15:04:15 2010 -0200
>> +++ b/linux/include/media/soc_camera.h	Wed Jan 27 20:49:57 2010 +0100
>> @@ -264,9 +264,8 @@
>>  		common_flags;
>>  }
>>
>> -static inline void soc_camera_limit_side(unsigned int *start,
>> -		unsigned int *length, unsigned int start_min,
>> -		unsigned int length_min, unsigned int length_max)
>> +static inline void soc_camera_limit_side(int *start, int *length,
>> +		int start_min, int length_min, int length_max)
>>  {
>>  	if (*length < length_min)
>>  		*length = length_min;
> 
> I still do not believe this function will work equally well with signed 
> parameters, as it works with unsigned ones.

I implemented some test cases to find out whether the
soc_camera_limit_side() works correctly or not. My biggest problem is that I'm
not sure what is the expected working of the soc_camera_limit_side() function.

Nevertheless I tried expect some values, you can probably verify whether my
expectations are correct or not (see the test attached).

The signed and unsigned version of the function works differently because
the unsigned version cannot accept negative values. These values will be
implicitly casted to an unsigned value which means that they will be interpreted
as a big positive value.

Here are the test results:

Test Case 1: PASSED
Test Case 2: PASSED
Test Case 3: FAILED: start=50, length=8, start_unsigned=0, length_unsigned=1600
Test Case 4: PASSED
Test Case 5: PASSED
Test Case 6: PASSED
Test Case 7: PASSED
Test Case 8: PASSED

There is a difference in case 3, but which is the correct one?

Regard,

	Márton Németh

--------------050906040806050800030403
Content-Type: text/x-csrc;
 name="test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test.c"


#include <stdio.h>

static inline void soc_camera_limit_side_UNSIGNED(unsigned int *start, unsigned int *length,
		unsigned int start_min, unsigned int length_min, unsigned int length_max)
{
	if (*length < length_min)
		*length = length_min;
	else if (*length > length_max)
		*length = length_max;

	if (*start < start_min)
		*start = start_min;
	else if (*start > start_min + length_max - *length)
		*start = start_min + length_max - *length;
}


static inline void soc_camera_limit_side(int *start, int *length,
		int start_min, int length_min, int length_max)
{
	if (*length < length_min)
		*length = length_min;
	else if (*length > length_max)
		*length = length_max;

	if (*start < start_min)
		*start = start_min;
	else if (*start > start_min + length_max - *length)
		*start = start_min + length_max - *length;
}


int main() {
	int start, length;
	unsigned int start_unsigned, length_unsigned;

	printf("Test Case 1: ");
	start = 0;
	length = 8;
	start_unsigned = start;
	length_unsigned = length;
	soc_camera_limit_side(&start, &length, 0, 8, 1600);
	soc_camera_limit_side_UNSIGNED(&start_unsigned, &length_unsigned, 0, 8, 1600);
	if (start == 0 && length == 8 && start_unsigned == start && length_unsigned == length) {
		printf("PASSED\n");
	} else {
		printf("FAILED: start=%i, length=%i, start_unsigned=%i, length_unsigned=%i\n", start, length, start_unsigned, length_unsigned);
	}

	printf("Test Case 2: ");
	start = -5;
	length = 1600;
	start_unsigned = start;
	length_unsigned = length;
	soc_camera_limit_side(&start, &length, 0, 8, 1600);
	soc_camera_limit_side_UNSIGNED(&start_unsigned, &length_unsigned, 0, 8, 1600);
	if (start == 0 && length == 1600 && start_unsigned == start && length_unsigned == length) {
		printf("PASSED\n");
	} else {
		printf("FAILED: start=%i, length=%i, start_unsigned=%i, length_unsigned=%i\n", start, length, start_unsigned, length_unsigned);
	}

	printf("Test Case 3: ");
	start = 50;
	length = -15;
	start_unsigned = start;
	length_unsigned = length;
	soc_camera_limit_side(&start, &length, 0, 8, 1600);
	soc_camera_limit_side_UNSIGNED(&start_unsigned, &length_unsigned, 0, 8, 1600);
	if (start == 50 && length == 8 && start_unsigned == start && length_unsigned == length) {
		printf("PASSED\n");
	} else {
		printf("FAILED: start=%i, length=%i, start_unsigned=%i, length_unsigned=%i\n", start, length, start_unsigned, length_unsigned);
	}

	printf("Test Case 4: ");
	start = 500;
	length = 2000;
	start_unsigned = start;
	length_unsigned = length;
	soc_camera_limit_side(&start, &length, 0, 8, 1600);
	soc_camera_limit_side_UNSIGNED(&start_unsigned, &length_unsigned, 0, 8, 1600);
	if (start == 0 && length == 1600 && start_unsigned == start && length_unsigned == length) {
		printf("PASSED\n");
	} else {
		printf("FAILED: start=%i, length=%i, start_unsigned=%i, length_unsigned=%i\n", start, length, start_unsigned, length_unsigned);
	}

	printf("Test Case 5: ");
	start = -20;
	length = 1600;
	start_unsigned = start;
	length_unsigned = length;
	soc_camera_limit_side(&start, &length, 100, 8, 1600);
	soc_camera_limit_side_UNSIGNED(&start_unsigned, &length_unsigned, 100, 8, 1600);
	if (start == 100 && length == 1600 && start_unsigned == start && length_unsigned == length) {
		printf("PASSED\n");
	} else {
		printf("FAILED: start=%i, length=%i, start_unsigned=%i, length_unsigned=%i\n", start, length, start_unsigned, length_unsigned);
	}

	printf("Test Case 6: ");
	start = 1600;
	length = 1600;
	start_unsigned = start;
	length_unsigned = length;
	soc_camera_limit_side(&start, &length, 100, 8, 1600);
	soc_camera_limit_side_UNSIGNED(&start_unsigned, &length_unsigned, 100, 8, 1600);
	if (start == 100 && length == 1600 && start_unsigned == start && length_unsigned == length) {
		printf("PASSED\n");
	} else {
		printf("FAILED: start=%i, length=%i, start_unsigned=%i, length_unsigned=%i\n", start, length, start_unsigned, length_unsigned);
	}

	printf("Test Case 7: ");
	start = 5;
	length = 300;
	start_unsigned = start;
	length_unsigned = length;
	soc_camera_limit_side(&start, &length, 100, 8, 1600);
	soc_camera_limit_side_UNSIGNED(&start_unsigned, &length_unsigned, 100, 8, 1600);
	if (start == 100 && length == 300 && start_unsigned == start && length_unsigned == length) {
		printf("PASSED\n");
	} else {
		printf("FAILED: start=%i, length=%i, start_unsigned=%i, length_unsigned=%i\n", start, length, start_unsigned, length_unsigned);
	}

	printf("Test Case 8: ");
	start = 200;
	length = 4;
	start_unsigned = start;
	length_unsigned = length;
	soc_camera_limit_side(&start, &length, 100, 8, 1600);
	soc_camera_limit_side_UNSIGNED(&start_unsigned, &length_unsigned, 100, 8, 1600);
	if (start == 200 && length == 8 && start_unsigned == start && length_unsigned == length) {
		printf("PASSED\n");
	} else {
		printf("FAILED: start=%i, length=%i, start_unsigned=%i, length_unsigned=%i\n", start, length, start_unsigned, length_unsigned);
	}

	return 0;
}


--------------050906040806050800030403--

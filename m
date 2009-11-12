Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:58677 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZKLHTO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 02:19:14 -0500
Message-ID: <4AFBB6F3.3080306@freemail.hu>
Date: Thu, 12 Nov 2009 08:19:15 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] decode_tm6000: fix include path
References: <4AFBB0C3.8000509@freemail.hu> <200911120815.03113.hverkuil@xs4all.nl>
In-Reply-To: <200911120815.03113.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Thursday 12 November 2009 07:52:51 Németh Márton wrote:
>> From: Márton Németh <nm127@freemail.hu>
>>
>> The include path is changed from ../lib to ../lib4vl2util .
>>
>> Signed-off-by: Márton Németh <nm127@freemail.hu>
>> ---
>> diff -r 60f784aa071d v4l2-apps/util/decode_tm6000.c
>> --- a/v4l2-apps/util/decode_tm6000.c	Wed Nov 11 18:28:53 2009 +0100
>> +++ b/v4l2-apps/util/decode_tm6000.c	Thu Nov 12 07:49:43 2009 +0100
>> @@ -16,7 +16,7 @@
>>     along with this program; if not, write to the Free Software
>>     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>>   */
>> -#include "../lib/v4l2_driver.h"
>> +#include "../libv4l2util/v4l2_driver.h"
>>  #include <stdio.h>
>>  #include <string.h>
>>  #include <argp.h>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> This is already part of my pull request from Monday. So this will hopefully be
> merged soon.

OK. Sorry I missed that one.

Regards,

	Márton Németh


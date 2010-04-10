Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:32904 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab0DJPOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Apr 2010 11:14:37 -0400
Received: by fxm23 with SMTP id 23so3370781fxm.21
        for <linux-media@vger.kernel.org>; Sat, 10 Apr 2010 08:14:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1270857748.8003.7.camel@pc07.localdom.local>
References: <y2p94764e701004091616x59467e3qc4efc2580dad53d@mail.gmail.com>
	 <1270857748.8003.7.camel@pc07.localdom.local>
Date: Sat, 10 Apr 2010 18:14:35 +0300
Message-ID: <x2h94764e701004100814k2fa8b3fcq29868b73da1fc36c@mail.gmail.com>
Subject: Re: [PATCH] DVB-T initial scan file for Israel (dvb-utils)
From: Shaul Kremer <shaulkr@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 10, 2010 at 3:02 AM, hermann pitton <hermann-pitton@arcor.de> wrote:
> Hi Shaul,
>
> Am Samstag, den 10.04.2010, 02:16 +0300 schrieb Shaul Kremer:
>> Hi,
>>
>> Here is an initial scan file for IBA's DVB-T transmitters.
>>
>> Generated from info at http://www.iba.org.il/reception/ (Hebrew)
>>
>> # HG changeset patch
>> # User Shaul Kremer <shaulkr@gmail.com>
>> # Date 1270854557 -10800
>> # Node ID ac84f6db6f031db82509c247ac1775ca48b0e2f3
>> # Parent  7de0663facd92bbb9049aeeda3dcba9601228f30
>> Added DVB-T initial tuning tables for Israel.
>>
>> diff -r 7de0663facd9 -r ac84f6db6f03 util/scan/dvb-t/il-SFN1
>> --- /dev/null   Thu Jan 01 00:00:00 1970 +0000
>> +++ b/util/scan/dvb-t/il-SFN1   Sat Apr 10 02:09:17 2010 +0300
>> @@ -0,0 +1,4 @@
>> +# Israel, Israel Broadcasting Authority's SFN-1 transmitter (northern Israel)
>> +# Generated from list in http://www.iba.org.il/reception/
>> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
>> +T 538000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
>> diff -r 7de0663facd9 -r ac84f6db6f03 util/scan/dvb-t/il-SFN2
>> --- /dev/null   Thu Jan 01 00:00:00 1970 +0000
>> +++ b/util/scan/dvb-t/il-SFN2   Sat Apr 10 02:09:17 2010 +0300
>> @@ -0,0 +1,4 @@
>> +# Israel, Israel Broadcasting Authority's SFN-2 transmitter (central Israel)
>> +# Generated from list in http://www.iba.org.il/reception/
>> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
>> +T 514000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
>> diff -r 7de0663facd9 -r ac84f6db6f03 util/scan/dvb-t/il-SFN3
>> --- /dev/null   Thu Jan 01 00:00:00 1970 +0000
>> +++ b/util/scan/dvb-t/il-SFN3   Sat Apr 10 02:09:17 2010 +0300
>> @@ -0,0 +1,4 @@
>> +# Israel, Israel Broadcasting Authority's SFN-3 transmitter (southern Israel)
>> +# Generated from list in http://www.iba.org.il/reception/
>> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
>> +T 538000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
>
> why you don't put them into one scan file for now?
>
> "scan" for sure does not know about any difference between northern and
> southern Israel from the above and to scan the central transponder too
> in one run might cost in worst case a few seconds.
>
> Cheers,
> Hermann
>
>
>

Sounds good. Here:

# HG changeset patch
# User Shaul Kremer <shaulkr@gmail.com>
# Date 1270911802 -10800
# Node ID 9c2dabea9d1b63a75593b920d41159e7ba607747
# Parent  7de0663facd92bbb9049aeeda3dcba9601228f30
Added DVB-T initial tuning tables for Israel.

diff -r 7de0663facd9 -r 9c2dabea9d1b util/scan/dvb-t/il-All
--- /dev/null   Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/il-All    Sat Apr 10 18:03:22 2010 +0300
@@ -0,0 +1,5 @@
+# Israel, Israel Broadcasting Authority's transmitters
+# Generated from list in http://www.iba.org.il/reception/
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
+T 538000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f43.google.com ([209.85.212.43]:54889 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab1IHE2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 00:28:31 -0400
Received: by vws10 with SMTP id 10so593895vws.2
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2011 21:28:30 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 8 Sep 2011 00:28:30 -0400
Message-ID: <CAHAyoxyG9pS+3pOSQYepXsc+HDLGiW8EOud10JaXjas4Ku0fxw@mail.gmail.com>
Subject: [PULL] git://git.linuxtv.org/mkrufky/mxl111sf.git mfe-fixes | WAS:
 Re: [git:v4l-dvb/for_v3.2] [media] dvb-usb: refactor MFE code for individual
 streaming config per frontend
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>>>>> On 09/08/2011 12:18 AM, Antti Palosaari wrote:
>>>>>>> This patch seems to break all DVB USB devices we have. Michael, could
>>>>>>> you check and fix it asap.
[snip]
>>>>>>>> Subject: [media] dvb-usb: refactor MFE code for individual streaming
>>>>>>>> config per frontend
[snip]
>>>>>> This error is shown by VLC when channel changed:
>>>>>>
>>>>>> [0x7f1bbc000cd0] dvb access error: DMXSetFilter: failed with -1 (Invalid
>>>>>> argument)
>>>>>> [0x7f1bbc000cd0] dvb access error: DMXSetFilter failed
>>>>>> [0x7f1bbc32f910] main stream error: cannot pre fill buffer
>>>>>>
>>>>>> but it seems to be related dvb_usb_ctrl_feed() I pointed earlier mail.
[snip]
>>>
>>> Commenting out that
>>>>>>> if ((adap->feedcount == onoff)&&  (!onoff))
>>>>>>> adap->active_fe = -1;
>>>
>>> resolves problem.
>>
>> OK...  I think it's safe to remove that code.  The only time that
>> "adap->active_fe" should really be set to -1 is at startup, before
>> *any* frontend is used.  Does removal of those two lines fix it for
>> you completely?
>
> BTW, I understand the cause of this now -- this error case occurs when
> the application stops streaming but leaves the frontend open.  (for
> instance, to change the channel)  We only want to set (adap->active_fe
> = -1) if ( ((adap->feedcount == onoff)&&  (!onoff)) AND ALSO only if
> the file handle gets closed.
>
> It's safe to just disable those lines for now.

Mauro,

Please pull from git://git.linuxtv.org/mkrufky/mxl111sf.git mfe-fixes
branch, to fix the issue that Antti pointed out.


The following changes since commit d4d4e3c97211f20d4fde5d82878561adaa42b578:
  Sylwester Nawrocki (1):
        [media] s5p-csis: Rework the system suspend/resume helpers

are available in the git repository at:

  git://git.linuxtv.org/mkrufky/mxl111sf.git mfe-fixes

Michael Krufky (2):
      dvb-usb: fix streaming failure on channel change
      dvb-usb: improve sanity check of adap->active_fe in dvb_usb_ctrl_feed

 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

Cheers,

Michael Krufky

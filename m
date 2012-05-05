Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62969 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2EEAZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 20:25:46 -0400
Received: by werb10 with SMTP id b10so233212wer.19
        for <linux-media@vger.kernel.org>; Fri, 04 May 2012 17:25:45 -0700 (PDT)
Message-ID: <4FA471CC.5020207@gmail.com>
Date: Sat, 05 May 2012 02:18:20 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] add support for DeLOCK-USB-2.0-DVB-T-Receiver-61744
References: <4F9E5D91.30503@gmail.com> <1335800374-22012-2-git-send-email-thomas.mair86@googlemail.com> <4F9F8752.40609@gmail.com> <4FA232CE.8010404@gmail.com> <4FA249DE.7000702@gmail.com> <4FA33084.7050204@gmail.com> <CAKZ=SG8SjH1C0E38iGjQfJvzi+uTy=dL_9jOxAetgOhkUp5t7g@mail.gmail.com>
In-Reply-To: <CAKZ=SG8SjH1C0E38iGjQfJvzi+uTy=dL_9jOxAetgOhkUp5t7g@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/04/2012 08:50 AM, Thomas Mair wrote:
> Am 04.05.2012 03:27 schrieb "poma" <pomidorabelisima@gmail.com>:
>>
>> On 05/03/2012 11:03 AM, Gianluca Gennari wrote:
>>> Hi poma,
>>> I have a 0BDA:2838 (Easycap EZTV646) and a 0BDA:2832 (no name 20x20mm
>>> mini DVB-T stick) and both are based on the E4000 tuner, which is not
>>> supported in the kernel at the moment.
>>> I have no idea if there are sticks with the same USB PID and the fc0012
>>> tuner.
>>
>> OK, second one - no name device is "Realtek RTL2832U reference design"**.
>>
>> First one:
>> Once upon a time there was a "EasyCAP"…
>> "After while crocodile!"
>> …and "EzCAP" was born.
>> http://szforwardvideo.en.alibaba.com/aboutus.html
>> Obviously Easycap EZTV646 != EzCAP EzTV646
>>
> http://www.reddit.com/r/RTLSDR/comments/s6ddo/rtlsdr_compatibility_list_v2_work_in_progress/
>> ezcap EzTV646   0BDA:2838       RTL2832U/FC0012         Some revisions
> may have the E4000*
>> http://i.imgur.com/mFD1X.jpg
>> (Generic)       0BDa:2838       RTL2832U/E4000*
>> …
>> And, in addition:
>> http://sdr.osmocom.org/trac/wiki/rtl-sdr
>> 0x0bda  0x2832  all of them     Generic RTL2832U (e.g. hama nano)**
>> 0x0bda  0x2838  E4000   ezcap USB 2.0 DVB-T/DAB/FM dongle
>> …
>> Maybe?
>> https://sites.google.com/site/myrtlsdr/
>> "EzCap EZTV646 has got RTL2832U/FC0012. However rtl-sdr must be tweaked
>> to force FC0012 tuner because it has the same PID as EZTV668 (PID:
>> 0x2838) so running it whithout a tweak will select Elonics E4000 tuner.
>> Works, not so good at filtering."
>> …
>> Conclusion:
>> At least two devices share same vid/pid with different tuners - fc0012
>> vs e4000.
>> How to resolve this from a drivers perspective in a proper way?
> The handling of the different tuners of devices with the same vid/pid
> should not be a problem, because rtl28xxu driver probes for the tuner when
> the device is initialized.
> 
Thanks for clarifying!
rtl28xxu.c:
…
* Probe used tuner. We need to know used tuner before demod attach
* since there is some demod params needed to set according to tuner.
…
/* check FC0012 ID register; reg=00 val=a1 */
…

>> Beside,
>> there is GPL'ed 'e4k' tuner source code aka 'e4000 improved'*** (Elonics
>> E4000)
>> by Harald Welte
>> http://cgit.osmocom.org/cgit/osmo-sdr/tree/firmware/src/tuner_e4k.c
>> http://sdr.osmocom.org/trac/
>> http://sdr.osmocom.org/trac/wiki/rtl-sdr
>> http://wiki.spench.net/wiki/RTL2832U***
> So what is missing is the e4000 tuner driver.
> 
True.

> Btw i do have a list of devices that include the Rtl2832 demod. I will send
> that list on the weekend.
> 
Groovy!

> Regards
> Thomas
> 

regards,
poma


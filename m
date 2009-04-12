Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:6135 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbZDLLY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2009 07:24:58 -0400
Received: by yx-out-2324.google.com with SMTP id 31so1822346yxl.1
        for <linux-media@vger.kernel.org>; Sun, 12 Apr 2009 04:24:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dbfdd9d80904071200h4e9063a5obc030565731659fa@mail.gmail.com>
References: <dbfdd9d80904021914s3a0cc0a4ufb444d81915e612b@mail.gmail.com>
	 <dbfdd9d80904061015g1f34dbael113fccfd667cb77b@mail.gmail.com>
	 <20090407095718.3f15b8a6@free.fr>
	 <dbfdd9d80904071200h4e9063a5obc030565731659fa@mail.gmail.com>
Date: Sun, 12 Apr 2009 07:24:57 -0400
Message-ID: <dbfdd9d80904120424r206cd869pa36a472e10377b12@mail.gmail.com>
Subject: Re: Compile of gspca
From: "Tom & Merry Cada" <thecadas@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

** Sorry this didn't get to the list. I must be more careful of my
replies... Tom ***

On Tue, Apr 7, 2009 at 3:00 PM, Tom & Merry Cada <thecadas@gmail.com> wrote:
> On Tue, Apr 7, 2009 at 3:57 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
>> On Mon, 6 Apr 2009 13:15:26 -0400
>> "Tom & Merry Cada" <thecadas@gmail.com> wrote:
>>
>>> Video in skype works great. However, now the sound does not work
>>> (sigh...). The USB mic is shown in ALSA mixer as card 1 with the gain
>>> up at max. The mic is shown in the pulseaudio mixer as an input
>>> device, but no sound to either skype or the gnome sound recorder.
>>>
>>> Is this a problem with gspca, or with the other components (ALSA,
>>> pulseaudio, OSS, or whatever - too many choices!). An external mic
>>> through the on-board sound card works properly.
>>>
>>> Any suggestions or direction would be most welcome.
>>
>> Hello Tom,
>>
>> I know that some integrated microphones do not work with gspca, and,
>> sorry, I could not find yet why...
>>
>> Regards.
>>
>> --
>

All is not lost. I have done extensive testing - sort of like a bull
rampaging in a china shop with the following results.

 First the operating parameters:

 Kernel Ubuntu 2.6.28-11-generic SMP 64bit

 Programs gspca-1a7449833166 compiled this morning.

 Camera Microsoft VX 3000 web-cam/microphone combination.

 It has been working on and off with sound sometimes and video
 sometimes but not both at once.
 I noticed from earlier documentation that the camera driver was the
 sn9c102 module.

 On boot, the modules gspca_main and gspca_sonixj are loaded. The
 microphone is detected and shows up in the pulseaudio mixer with no
 indication of sound (i.e. the sound level bar is empty).

 First:
 -  rmmod gspca_sonixj
 -  modprobe sn9c102.
 -  Result: There was no change in the mixer display.

 Second:
 modprobe gspca_sonixj
 -  Result: Mixer display shows a low level of noise  which jumps when
I speak. Mic is working. Ta-dah!

 Third:
 -  Start skype, and am able to make a test call with sound. I have
 gotten so tired of Test, 1, 2, 3,... that I now whistle. My wife
appreciates the change.

Fourth:
-  Enable the video in skype. Mic goes dead.  Sound disappears.

Fifth:
 -  rmmod gspca_sonixj
 -  modprobe gspca-sonixj
 Result: Sound is back. Of course the video is gone.

 I hope this can help in tracking down what is going on.

 Let me know if you need anything further, or if you wish for me to do
 any testing... Tom.

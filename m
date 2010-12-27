Return-path: <mchehab@gaivota>
Received: from flokli.de ([78.46.104.9]:55389 "EHLO asterix.flokli.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab0L0Ny5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 08:54:57 -0500
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: em28xx: Terratec Grabby no sound
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Dec 2010 14:54:56 +0100
From: Florian Klink <flokli@flokli.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <a2525f2e78a9eedccbe9c761de0685a8@flokli.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

 Hi Mauro,

 with the help of Bernd Spaeth, I finally managed to get the Terratec 
 Grabby
 working by using

 mplayer -v -tv
 driver=v4l2:input=0:device=/dev/video1:alsa:adevice=hw.2,0:audiorate=48000:forceaudio:immediatemode=0
 tv://

 and your patch

 diff --git a/drivers/media/video/em28xx/em28xx-cards.c
 b/drivers/media/video/em28xx/em28xx-cards.c
 index e7efb4b..6e80376 100644
 --- a/drivers/media/video/em28xx/em28xx-cards.c
 +++ b/drivers/media/video/em28xx/em28xx-cards.c
 @@ -1621,11 +1621,11 @@ struct em28xx_board em28xx_boards[] = {
  .input = { {
  .type = EM28XX_VMUX_COMPOSITE1,
  .vmux = SAA7115_COMPOSITE0,
 - .amux = EM28XX_AMUX_VIDEO2,
 + .amux = EM28XX_AMUX_LINE_IN,
  }, {
  .type = EM28XX_VMUX_SVIDEO,
  .vmux = SAA7115_SVIDEO3,
 - .amux = EM28XX_AMUX_VIDEO2,
 + .amux = EM28XX_AMUX_LINE_IN,
  } },
  },
  [EM2860_BOARD_TERRATEC_AV350] = {

 Working video and audio!

 I wasn't able to test it with s-video, only composite.

 But I think it's still safe to commit the patch, because s-video is 
 only
 another video input, the audio output stays the same.

 Florian

 On Tue, 09 Nov 2010 08:56:32 -0200, Mauro Carvalho Chehab wrote:

> Em 26-10-2010 10:58, Florian Klink escreveu:
>> Hi,
>>
>>> The sound comes from alsa device. Several em28xx types provide
>>> standard USB audio. So, snd-usb-audio handles it. That's why you 
>>> need
>>> alsa:adevice=hw.2,0:forceaudio at mplayer.
>> ... but thats my problem. sound doesn't appear inside mplayer, even
>> with the command line options set to use the "external" alsa device.
>> However, "arecord -D hw:2,0 -r 32000 -c 2 -f S16_LE | aplay -" plays
>> the sound, but only before mplayer tried to access the sound card
> Have you tried my patch? If you're using 
> alsa:adevice=hw.2,0:forceaudio
> at mplayer, you should not be running arecord/aplay. You need to use 
> one
> solution or the other.
>
>> When trying to play sound with arecord again after mplayer tried to
>> access it, I have to re-plug the card to get it playing sound over
>> arecord again, video only seems to not break it. There is no error
>> message or something in arecord when it's not playing anything, just
>> silence and the same command line output. Is there maybe anything 
>> with
>> the sample format S16_LE or something that confuses mplayer/the
>> driver/whatever? Strange problem... mplayer output (mplayer -v -tv
>> 
>> driver=v4l2:input=0:device=/dev/video1:alsa:adevice=hw.2,0:forceaudio
>> tv://): http://pastebin.com/yTV300iG [1] Florian -- To unsubscribe 
>> from
>> this list: send the line "unsubscribe linux-media" in the body of a
>> message to majordomo@vger.kernel.org [2] More majordomo info at
>> http://vger.kernel.org/majordomo-info.html [3]
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-media" in the body of a message to majordomo@vger.kernel.org 
> [4]
> More majordomo info at http://vger.kernel.org/majordomo-info.html [5]


 Links:
 ------
 [1] http://pastebin.com/yTV300iG
 [2] mailto:majordomo@vger.kernel.org
 [3] http://vger.kernel.org/majordomo-info.html
 [4] mailto:majordomo@vger.kernel.org
 [5] http://vger.kernel.org/majordomo-info.html

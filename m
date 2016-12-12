Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49854
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752038AbcLLLVw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 06:21:52 -0500
Date: Mon, 12 Dec 2016 09:21:41 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: mahasler@gmail.com
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] stk1160: Add module param for setting the record
 gain.
Message-ID: <20161212092141.022853df@vento.lan>
In-Reply-To: <20161211122006.GA9021@arch-desktop>
References: <20161127110732.GA5338@arch-desktop>
        <20161127111148.GA30483@arch-desktop>
        <20161202090558.29931492@vento.lan>
        <CAAEAJfCmQnQHWy+7kS4wuuBK7mubiKRpiDYCm9BHYjVR4yHGgA@mail.gmail.com>
        <CAOJOY2Nhi6aev=jwVeyuQMxKUAk-MfT0YLKsFfrUsAcZtdrysQ@mail.gmail.com>
        <CAAEAJfAoZCzh5c=C+8Um-KaZkRs_ip1kX04xZRm2bWrGLmMwjA@mail.gmail.com>
        <20161205101221.53613e57@vento.lan>
        <CAAEAJfD6sauJ_NyYtBmFAr5c_NGr8OuZwqnG1Ukk9-P7YNSypQ@mail.gmail.com>
        <CAOJOY2M6QANNysnZ_C9G+fFg=a=wYQXGDr49LCYGE7KrbwkE4A@mail.gmail.com>
        <20161206105626.7de242a3@vento.lan>
        <20161211122006.GA9021@arch-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 11 Dec 2016 13:20:06 +0100
mahasler@gmail.com escreveu:

> Sorry about the broken formatting. Here's the diff once more:

The patch itself looks ok. Just a few comments.

> 
> diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
> index 95648ac..708792b 100644
> --- a/drivers/media/usb/stk1160/stk1160-ac97.c
> +++ b/drivers/media/usb/stk1160/stk1160-ac97.c
> @@ -23,11 +23,30 @@
>   *
>   */
>  
> -#include <linux/module.h>

This change seems to be unrelated.

> +#include <linux/delay.h>
>  
>  #include "stk1160.h"
>  #include "stk1160-reg.h"
>  
> +static int stk1160_ac97_wait_transfer_complete(struct stk1160 *dev)
> +{
> +       unsigned long timeout = jiffies + msecs_to_jiffies(STK1160_AC97_TIMEOUT);
> +       u8 value;
> +
> +       /* Wait for AC97 transfer to complete */
> +       while (time_is_after_jiffies(timeout)) {
> +               stk1160_read_reg(dev, STK1160_AC97CTL_0, &value);
> +
> +               if (!(value & (STK1160_AC97CTL_0_CR | STK1160_AC97CTL_0_CW)))
> +                       return 0;
> +
> +               msleep(1);

It will likely sleep ~10ms. Maybe you likely need to use usleep_range().
Please read:
	Documentation/timers/timers-howto.txt

> +       }
> +
> +       stk1160_err("AC97 transfer took too long, this should never happen!");
> +       return -EBUSY;
> +}
> +
>  static void stk1160_write_ac97(struct stk1160 *dev, u16 reg, u16 value)
>  {
>         /* Set codec register address */
> @@ -37,11 +56,11 @@ static void stk1160_write_ac97(struct stk1160 *dev, u16 reg, u16 value)
>         stk1160_write_reg(dev, STK1160_AC97_CMD, value & 0xff);
>         stk1160_write_reg(dev, STK1160_AC97_CMD + 1, (value & 0xff00) >> 8);
>  
> -       /*
> -        * Set command write bit to initiate write operation.
> -        * The bit will be cleared when transfer is done.
> -        */
> +       /* Set command write bit to initiate write operation */
>         stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8c);
> +
> +       /* Wait for command write bit to be cleared */
> +       stk1160_ac97_wait_transfer_complete(dev);
>  }
>  
>  #ifdef DEBUG
> @@ -53,12 +72,14 @@ static u16 stk1160_read_ac97(struct stk1160 *dev, u16 reg)
>         /* Set codec register address */
>         stk1160_write_reg(dev, STK1160_AC97_ADDR, reg);
>  
> -       /*
> -        * Set command read bit to initiate read operation.
> -        * The bit will be cleared when transfer is done.
> -        */
> +       /* Set command read bit to initiate read operation */
>         stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8b);
>  
> +       /* Wait for command read bit to be cleared */
> +       if (stk1160_ac97_wait_transfer_complete(dev) < 0) {
> +               return 0;
> +       }
> +
>         /* Retrieve register value */
>         stk1160_read_reg(dev, STK1160_AC97_CMD, &vall);
>         stk1160_read_reg(dev, STK1160_AC97_CMD + 1, &valh);
> diff --git a/drivers/media/usb/stk1160/stk1160-reg.h b/drivers/media/usb/stk1160/stk1160-reg.h
> index 296a9e7..7b08a3c 100644
> --- a/drivers/media/usb/stk1160/stk1160-reg.h
> +++ b/drivers/media/usb/stk1160/stk1160-reg.h
> @@ -122,6 +122,8 @@
>  /* AC97 Audio Control */
>  #define STK1160_AC97CTL_0              0x500
>  #define STK1160_AC97CTL_1              0x504
> +#define  STK1160_AC97CTL_0_CR          BIT(1)
> +#define  STK1160_AC97CTL_0_CW          BIT(2)
>  
>  /* Use [0:6] bits of register 0x504 to set codec command address */
>  #define STK1160_AC97_ADDR              0x504
> diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
> index e85e12e..acd1c81 100644
> --- a/drivers/media/usb/stk1160/stk1160.h
> +++ b/drivers/media/usb/stk1160/stk1160.h
> @@ -50,6 +50,8 @@
>  #define STK1160_MAX_INPUT 4
>  #define STK1160_SVIDEO_INPUT 4
>  
> +#define STK1160_AC97_TIMEOUT 50
> +
>  #define STK1160_I2C_TIMEOUT 100
>  
>  
> 
> On Tue, Dec 06, 2016 at 10:56:26AM -0200, Mauro Carvalho Chehab wrote:
> > Em Mon, 5 Dec 2016 22:06:59 +0100
> > Marcel Hasler <mahasler@gmail.com> escreveu:
> >   
> > > Hello
> > > 
> > > 2016-12-05 16:38 GMT+01:00 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>:  
> > > > On 5 December 2016 at 09:12, Mauro Carvalho Chehab
> > > > <mchehab@s-opensource.com> wrote:    
> > > >> Em Sun, 4 Dec 2016 15:25:25 -0300
> > > >> Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> escreveu:
> > > >>    
> > > >>> On 4 December 2016 at 10:01, Marcel Hasler <mahasler@gmail.com> wrote:    
> > > >>> > Hello
> > > >>> >
> > > >>> > 2016-12-03 21:46 GMT+01:00 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>:    
> > > >>> >> On 2 December 2016 at 08:05, Mauro Carvalho Chehab
> > > >>> >> <mchehab@s-opensource.com> wrote:    
> > > >>> >>> Em Sun, 27 Nov 2016 12:11:48 +0100
> > > >>> >>> Marcel Hasler <mahasler@gmail.com> escreveu:
> > > >>> >>>    
> > > >>> >>>> Allow setting a custom record gain for the internal AC97 codec (if available). This can be
> > > >>> >>>> a value between 0 and 15, 8 is the default and should be suitable for most users. The Windows
> > > >>> >>>> driver also sets this to 8 without any possibility for changing it.    
> > > >>> >>>
> > > >>> >>> The problem of removing the mixer is that you need this kind of
> > > >>> >>> crap to setup the volumes on a non-standard way.
> > > >>> >>>    
> > > >>> >>
> > > >>> >> Right, that's a good point.
> > > >>> >>    
> > > >>> >>> NACK.
> > > >>> >>>
> > > >>> >>> Instead, keep the alsa mixer. The way other drivers do (for example,
> > > >>> >>> em28xx) is that they configure the mixer when an input is selected,
> > > >>> >>> increasing the volume of the active audio channel to 100% and muting
> > > >>> >>> the other audio channels. Yet, as the alsa mixer is exported, users
> > > >>> >>> can change the mixer settings in runtime using some alsa (or pa)
> > > >>> >>> mixer application.
> > > >>> >>>    
> > > >>> >>
> > > >>> >> Yeah, the AC97 mixer we are currently leveraging
> > > >>> >> exposes many controls that have no meaning in this device,
> > > >>> >> so removing that still looks like an improvement.
> > > >>> >>
> > > >>> >> I guess the proper way is creating our own mixer
> > > >>> >> (not using snd_ac97_mixer)  exposing only the record
> > > >>> >> gain knob.
> > > >>> >>
> > > >>> >> Marcel, what do you think?
> > > >>> >> --
> > > >>> >> Ezequiel García, VanguardiaSur
> > > >>> >> www.vanguardiasur.com.ar    
> > > >>> >
> > > >>> > As I have written before, the recording gain isn't actually meant to
> > > >>> > be changed by the user. In the official Windows driver this value is
> > > >>> > hard-coded to 8 and cannot be changed in any way. And there really is
> > > >>> > no good reason why anyone should need to mess with it in the first
> > > >>> > place. The default value will give the best results in pretty much all
> > > >>> > cases and produces approximately the same volume as the internal 8-bit
> > > >>> > ADC whose gain cannot be changed at all, not even by a driver.
> > > >>> >
> > > >>> > I had considered writing a mixer but chose not to. If the gain setting
> > > >>> > is openly exposed to mixer applications, how do you tell the users
> > > >>> > that the value set by the driver already is the optimal and
> > > >>> > recommended value and that they shouldn't mess with the controls
> > > >>> > unless they really have to? By having a module parameter, this setting
> > > >>> > is practically hidden from the normal user but still is available to
> > > >>> > power-users if they think they really need it. In the end it's really
> > > >>> > just a compromise between hiding it completely and exposing it openly.
> > > >>> > Also, this way the driver guarantees reproducible results, since
> > > >>> > there's no need to remember the positions of any volume sliders.
> > > >>> >    
> > > >>>
> > > >>> Hm, right. I've never changed the record gain, and it's true that it
> > > >>> doens't really improve the volume. So, I would be OK with having
> > > >>> a module parameter.
> > > >>>
> > > >>> On the other side, we are exposing it currently, through the "Capture"
> > > >>> mixer control:
> > > >>>
> > > >>> Simple mixer control 'Capture',0
> > > >>>   Capabilities: cvolume cswitch cswitch-joined
> > > >>>   Capture channels: Front Left - Front Right
> > > >>>   Limits: Capture 0 - 15
> > > >>>   Front Left: Capture 10 [67%] [15.00dB] [on]
> > > >>>   Front Right: Capture 8 [53%] [12.00dB] [on]
> > > >>>
> > > >>> So, it would be user-friendly to keep the user interface and continue
> > > >>> to expose the same knob - even if the default is the optimal, etc.
> > > >>>
> > > >>> To be completely honest, I don't think any user is really relying
> > > >>> on any REC_GAIN / Capture setting, and I'm completely OK
> > > >>> with having a mixer control or a module parameter. It doesn't matter.    
> > > >>
> > > >> If you're positive that *all* stk1160 use the ac97 mixer the
> > > >> same way, and that there's no sense on having a mixer for it,
> > > >> then it would be ok to remove it.
> > > >>    
> > > >
> > > > Let's remove it then!
> > > >    
> > > >> In such case, then why you need a modprobe parameter to allow
> > > >> setting the record level? If this mixer entry is not used,
> > > >> just set it to zero and be happy with that.
> > > >>    
> > > >
> > > > Let's remove the module param too, then.    
> > > 
> > > I'm okay with that.
> > >   
> > > >
> > > > Thanks,
> > > > --
> > > > Ezequiel García, VanguardiaSur
> > > > www.vanguardiasur.com.ar    
> > > 
> > > I'm willing to prepare one final patchset, provided we can agree on
> > > and resolve all issues beforehand.
> > > 
> > > So far the changes would be to remove the module param and to poll
> > > STK1160_AC97CTL_0 instead of using a fixed delay. It's probably better
> > > to also poll it before writing, although that never caused problems.  
> > 
> > Sounds ok. My experience with AC97 on em28xx is that, as new devices
> > were added, the delay needed for AC97 varied on some of those new
> > devices. That's why checking if AC97 is ready before writing was
> > added to its code.
> >   
> > > 
> > > I'll post some code for review before actually submitting patches.
> > > Mauro, is there anything else that you think should be changed? If so,
> > > please tell me now. Thanks.
> > > 
> > > Best regards
> > > Marcel  
> > 
> > 
> > 
> > Thanks,
> > Mauro  
> 
> Marcel



Thanks,
Mauro

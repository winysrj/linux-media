Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KedbI-0004fy-HR
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 00:28:30 +0200
Received: by ey-out-2122.google.com with SMTP id 25so638647eya.17
	for <linux-dvb@linuxtv.org>; Sat, 13 Sep 2008 15:28:16 -0700 (PDT)
Message-ID: <412bdbff0809131528h22171a3am434cd5e2500f40db@mail.gmail.com>
Date: Sat, 13 Sep 2008 18:28:16 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48CC3651.5040502@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0809131441k5f38931cr7d64dc3871c37987@mail.gmail.com>
	<48CC3651.5040502@linuxtv.org>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Power management and dvb framework
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello Steven,

On Sat, Sep 13, 2008 at 5:53 PM, Steven Toth <stoth@linuxtv.org> wrote:
> I looked at some power stuff for the au0828 recently. I added a couple of
> callbacks in the USB_register struct IIRC, I had those drive the gpios. I
> don't recall the details but if you look at the definition of the structure
> you should see some power related callbacks. Actually, I'm not even sure if
> those patches got merged.
>
> Also, the demod _init() and _sleep()  callbacks get called by dvb-core when
> the demod is required (or not). These might help.
>
> Lastly, depending on how the driver implements DVB, is might use videobuf -
> or it might do it's own buffer handing. In case of the latter, look at the
> feed_start() feed_stop() functions and the struct specific feed counter that
> usually accompanies this... you could probably add some useful power related
> stuff with these indications.

Thanks for the suggestions.  At this point my best bet is to just
litter the code with some printk() messages so I can see what the
complete workflow is for the life of a device.  That will help alot
with figuring out where at what point which hooks get called.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

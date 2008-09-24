Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KiZkB-0005eu-0x
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 21:09:49 +0200
From: Darron Broad <darron@kewl.org>
To: Anders Semb Hermansen <anders@ginandtonic.no>
In-reply-to: <8C08530B-BAD7-4E83-B1CA-6AB66EE9F53F@ginandtonic.no> 
References: <953A45C4-975B-4A05-8B41-AE8A486D0CA6@ginandtonic.no>
	<5584.1222273099@kewl.org>
	<F70AC72F-8DF3-4A9A-BFA1-A4FED9D3EABC@ginandtonic.no>
	<6380.1222276810@kewl.org>
	<8C08530B-BAD7-4E83-B1CA-6AB66EE9F53F@ginandtonic.no>
Date: Wed, 24 Sep 2008 20:09:42 +0100
Message-ID: <7674.1222283382@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-4000 and analogue tv
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <8C08530B-BAD7-4E83-B1CA-6AB66EE9F53F@ginandtonic.no>, Anders Semb Hermansen wrote:

lo

>Den 24. sep.. 2008 kl. 19.20 skrev Darron Broad:
>
><snip>
>
>> <snip>
>>>
>>> Does this mean that mythtv is doing something weird or maybe just
>>> using the v4l api in a different way which the driver cannot handle?
>>
>> This is feasable. I will take a look if I get the time but this
>> is more than likely to be when I have other reasons to look
>> at mythtv so don't expect an immediate response :-)
>>
>
>I did some more investigating.
>
>I thought maybe this had something to do with the tuner, since I got  
>snow. So I enabled debugging for the tuner module (debug=1). What I  
>saw was that when I started watching TV in myth, there was a  
>TUNER_SET_STANDBY after frequency and other things was set. This  
>TUNER_SET_STANDBY did not appear when I was just changing channel (and  
>picture worked).
>
>So I searched the driver for TUNER_STANDBY and found one which I  
>tried. Here is what I did:
>
>diff -r e5ca4534b543 linux/drivers/media/video/cx88/cx88-video.c
>--- a/linux/drivers/media/video/cx88/cx88-video.c       Tue Sep 09  
>08:29:56 2008 -0700
>+++ b/linux/drivers/media/video/cx88/cx88-video.c       Wed Sep 24  
>20:35:46 2008 +0200
>@@ -1152,7 +1152,8 @@
>         file->private_data = NULL;
>         kfree(fh);
>
>-       cx88_call_i2c_clients (dev->core, TUNER_SET_STANDBY, NULL);
>+       printk("Don't set standby mode! TUNER_SET_STANDBY NO SIR!");
>+       //cx88_call_i2c_clients (dev->core, TUNER_SET_STANDBY, NULL);
>
>         return 0;
>  }
>
>
>This fixed it!!
>
>I don't know what side effects this will have. Or if this is caused by  
>wrong use of v4l by mythtv, or driver not implementing it correctly.  
>Those who know the codebase can maybe answer that and come up with a  
>better permanent solution.

I admit I found your fix interesting. In fact, you can reproduce
this using tvtime and cat.

Eg.

> tvtime -d /dev/video0 &
> cat /dev/video0

The problem in mythtv appears to be in OpenV4L2DeviceAsInput(void)
where is opens the video device twice although I have no confirmed it.

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

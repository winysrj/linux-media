Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:54476 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759774AbZBESr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2009 13:47:29 -0500
Date: Thu, 5 Feb 2009 12:59:21 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Jean-Francois Moine <moinejf@free.fr>
cc: Adam Baker <linux@baker-net.org.uk>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Make sure gspca cleans up USB resources during
 disconnect
In-Reply-To: <20090205123947.0ba06e44@free.fr>
Message-ID: <alpine.LNX.2.00.0902051237400.5068@banach.math.auburn.edu>
References: <200902032313.17538.linux@baker-net.org.uk> <20090204174008.31846f22@free.fr> <200902042207.44867.linux@baker-net.org.uk> <20090205123947.0ba06e44@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 5 Feb 2009, Jean-Francois Moine wrote:

> On Wed, 4 Feb 2009 22:07:44 +0000
> Adam Baker <linux@baker-net.org.uk> wrote:
>
>> Thank You - If it wasn't for your work on gspca I'd still be using a
>> buggy old driver that had no chance of making it to main line.

Well, I would not have been using it, actually. It was too much of a mess. 
As to the "thanks" I definitely second that. To put together over-arching 
projects which provide an API and a context for doing things like this is 
definitely the way to go, and this one has been put together with some 
thought, over a period of time. This brings up a question I have been 
nmeaning to ask for some time: Whie we are thanking people, it does occur 
to me to ask what has happened to Michel Xhaard. We used to correspond 
occasionally. We had different interests, with some intersection. I was 
specializing in still cameras, and he was doing the webcam project from 
which gspca has evolved. Our common interesection of interests, of course, 
were about such matters as decompression algorithms, as well as pointing 
each other to new cameras to look at. But the last time I sent Michel an 
e-mail, which was about a two months ago or so, I did not get any answer.

>
> OK. It seems everything works fine with your webcam(s) (and the other
> ones).
>
> I added some more checks of the device presence and fixed a bit the API.
>
> Are you ready to send me a patch for the driver?
>
> I have just a remark: in sd_init (probe/resume), you do
>
> 	dev->work_thread = NULL;
> 	INIT_WORK(&dev->work_struct, sq905_dostream);
>
> The first line is not needed, and the second should be done in
> sd_config (probe only - on resume, the work will remain the same).
>
> Also, the BUG_ON in sd_start is not needed.
>
> About finepix, indeed, it asks for fixes, but also, it would be
> simplified with a workqueue...

Just to be clear about this:

Jean-Francois, you sent out a separate mail about doing a pull, which, I 
assume contains the changes in gspca which you mention above, So, what you 
want now is a few minor revisions in the sq905 module, in accordance with 
what is above, and then some final testing.

Adam, I guess I will let you work on that first, unless I get nothing back 
in the next several hours. Right now, I need to take a rest. I can barely 
see the monitor. I went to a scheduled appointment this morning to the eye 
doctor and got the drops in the eyes. It takes a few hours to wear off.

Er, wait a minute. Adam, did we forget to put in the changes which will 
permit the resolution setting to be changed? Yes, I think we did, what 
with all this other excitement. So now we have the choice to try to do 
that right, once and for all, or just to send this in and try to do 
something like that later. What kind of a schedule are we supposed to 
keep, now?

That was really fun, yesterday, hooking up two cameras at once. Just 
think, we could go around with one camera on the forehead, like a miner's 
lamp, and the second one hung on the ass to see where one has been. I 
didn't know that would work. But it did. And that is kind of neat.

Theodore Kilgore


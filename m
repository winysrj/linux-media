Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4THJSHD028943
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 13:19:28 -0400
Received: from patton.snap.tv ([213.161.191.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4THJCOw018153
	for <video4linux-list@redhat.com>; Thu, 29 May 2008 13:19:13 -0400
From: Sigmund Augdal <sigmund@snap.tv>
To: Dinesh Bhat <dbhat@linsys.ca>
In-Reply-To: <483C7696.9060004@linsys.ca>
References: <483C7696.9060004@linsys.ca>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 May 2008 18:41:49 +0200
Message-Id: <1212079309.26238.15.camel@rommel.snap.tv>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Video-4l-list <video4linux-list@redhat.com>, linux-dvb@linuxtv.org
Subject: Re: DVB ASI related question
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

tir, 27.05.2008 kl. 16.01 -0500, skrev Dinesh Bhat:
> Hello,
> 
> Please suggest if this is not a question relevant to this list.
> 
> I do not see support DVB over ASI on linuxtv.org. We are DVB/SDI over 
> ASI manufacturers and was wondering how much need is there in the market 
> for video 4 linux drivers for DVB ASI. Currently we have regular PCI 
> based drivers for Linux 2.6 and are thinking of porting our drivers to 
> V4L if there is need. I could not obtain enough information while 
> searching on the Internet.
It was discussed at some point wether to add the necessary apis to
handle ASI input devices to the linuxtv dvb api at some point. The post
that started the discussion can be read here:
http://www.mail-archive.com/linux-dvb@linuxtv.org/msg26193.html

I don't think the discussion ended in any conclution, and I don't think
anyone did anything towards adding ASI support. As you might know linux
multimedia support has two different sets of apis, one for dvb cards
(called "dvb" or "linuxtv dvb" and one for analog capture cards (called
v4l and v4l2). The previous discussion was about adding support for ASI
input boards to the dvb api. This would need some work because it
wouldn't be well defined how to "tune" a ASI card. I think you by this
mail suggested to add the ASI card as a v4l(2) driver. This might be a
good idea as this api is allready well defined for devices that don't
need to be tuned. Also many devices has arrived lately with hardware
encoders on them, so the api does handle capturing codec data.

So if you want to create a ASI capture card driver within the confines
of standard linux apis you have the following alternatives (as I see
it):

Use the DVB Api:
pros:
 * you can take advantage of the software pid and section filters in the
dvb framework
 * if your device supports hardware pid/section filters, apis will be
available to take advantage of them
 * userspace applications that handle mpeg2 ts often use this api, and
would be easy to adapt.
cons:
 * you might need to extend the apis to handle asi cards

Use the v4l2 api:
pros:
 * semantics are well defined.
 * provides an extensible api using so called "controls"
cons:
 * adapting user space applications will be more difficult
 * no reuse of software filters

Just my 2 norwegian øre

Sigmund Augdal


> 
> Any advice is appreciated.
> 
> Kind Regards,
> 
> Dinesh
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

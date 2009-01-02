Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n023EFsW018378
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 22:14:15 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n023DPxt005343
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 22:13:25 -0500
Date: Fri, 2 Jan 2009 01:13:19 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: video4linux-list@redhat.com, linux-dvb@linuxtv.org, v4l-dvb list
	<v4l-dvb-maintainer@linuxtv.org>
Message-ID: <20090102011319.73866370@pedra.chehab.org>
In-Reply-To: <20081028152152.GA22100@linuxtv.org>
References: <490525EA.4020608@rogers.com> <20081028152152.GA22100@linuxtv.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Merging V4L, DVB and Maintainers Mailing lists at VGER - Was: Re:
 [linux-dvb] Announcement: wiki merger and some loose ends
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

On Tue, 28 Oct 2008 16:21:52 +0100
Johannes Stezenbach <js@linuxtv.org> wrote:

> (about merging the linux-dvb and video4linux-list)
> 
> Maybe it would be a good idea to create a new
> list on vger.kernel.org which assimilates
> linux-dvb, video4linux-list and v4l-dvb-maintainer.
> vger.kernel.org has outstanding spam filters so their
> lists generally allow postings from non-subscribers.
> 
> How about just creating such a list as a replacement
> for v4l-dvb-maintainer, and then see if linux-dvb
> and video4linux-list users accept it and move
> their discussions over?

The idea of merging the mailing lists is running around for some time.

It took some time for me to have time to address this issue, but it finally
happened. We've just created it as:
	linux-media@vger.kernel.org

The idea is to replace the v4l-dvb-maintainer mailing list by
linux-media@vger.kernel.org, being the main point for both V4L and DVB
development.

One of the advantages is that vger anti-spam filters are very efficient, and we
can have the mailing list opened to bug reports from non-subscribers without
the risk of receiving lots of trash.

Also, almost all other kernel development mailing lists are there.

We'll probably integrate the mailing list soon with the newly-created
patchwork.kernel.org. Patchwork is a tool that allows the developers to do a
better job of handling patches without the risk of having patches lost
somewhere.

I'll later put an announcement after having the tool integrated with
linux-media@vger.kernel.org.

For now, I kindly want to invite you all, and specially the developers to
subscribe linux-media@vger.kernel.org.

To subscribe, just send an email to:

majordomo@vger.kernel.org

With the body containing:
subscribe linux-media

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757050Ab0JXR5A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Oct 2010 13:57:00 -0400
Message-ID: <4CC4735D.9040705@redhat.com>
Date: Sun, 24 Oct 2010 15:56:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jarod Wilson <jarod@redhat.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	LIRC Users <lirc-list@lists.sourceforge.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: V4L/DVB miniconf at Linux Plumbers 2010
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I've updated the themes that will be discussed during this year's LPC conference.
They're available at:

	http://wiki.linuxplumbersconf.org/2010:media_infrastructure

The media track is scheduled to happen on Friday, November 5, 2010 at 1:30 – 4:00pm.

Jarod/Vaibhav/Marek,

Please review. I've reserved 35 mins for presentations/discussions for each theme,
leaving 60 mins for other random discussions we may have at the end of the panel.
Please let me know if this is enough. Feel free to update the wiki with more information
that you may judge pertinent.

I hope to meet you all there!


Cheers,
Mauro

---
As the wiki page with the schedule may be later updated, for the records, the current 
contents is:


Several changes are happening at the Media Infrastructure in kernel, including:

    *  New Remote Controller subsystem;
    *  Events handling;
    *  Videobuf changes;
    *  …

Those changes will be discussed on the tracks bellow:

1) Multimedia Linux Remote Controllers – Jarod Wilson – 35 mins

A discussion about the state of video remote control integration in the linux kernel and userspace, focusing on Remote Control improvements.

Should include the following sub-themes:

    * IR remotes
    * Bluetooth remotes
    * RF4CE (802.15.4) remotes
    * Coordination of all types of remotes into a coherent framework
    * Pin coupling to radio remotes
    * Missing 802.15.4 networking infrastructure
    * X11 integration

2) Videobuf2 – the new Video for Linux driver framework – Marek Szyprowski – 35 mins

An effort to write a new framework to replace video buffering handling, called videobuf2 is currently underway. It will be more modular, have additional features and better support for new devices and platforms (including embedded).

3) Embedded Video devices: Can Linux handle such comples video Sub-System – Vaibhav Hiremath – 35 mins

This will be an open discussion, suggestions from other community experts, where we will discuss on few latest Embedded devices as an case-study.

4) Media infrastructure – Mauro Carvalho Chehab – 60 mins

This will discuss V4L/DVB/IR current issues and the next steps to improve the subsystem

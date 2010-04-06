Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:65081 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab0DFJdN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 05:33:13 -0400
MIME-Version: 1.0
In-Reply-To: <20100404193405.GA15065@elf.ucw.cz>
References: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com>
	<201003310125.26266.laurent.pinchart@ideasonboard.com> <v2x45cc95261003311251idfdc9b8anb7b2060618611d30@mail.gmail.com>
	<20100401165606.GA1677@ucw.cz> <87aatn9k7j.fsf@old-tantale.fifi.org>
	<20100404132223.GA1346@ucw.cz> <87ljd3ujrp.fsf@old-tantale.fifi.org>
	<20100404193405.GA15065@elf.ucw.cz>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Tue, 6 Apr 2010 11:32:46 +0200
Message-ID: <r2m45cc95261004060232y4c862040r9044bb435ad7eae5@mail.gmail.com>
Subject: Re: webcam problem after suspend/hibernate
To: Pavel Machek <pavel@ucw.cz>
Cc: Philippe Troin <phil@fifi.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi !

> Ok, that puts the problem firmly into uvcvideo area.
>
> Try changing its _resume routine to whatever is done on device
> unplug... it should be rather easy, and is quite close to "correct"
> solution.

I am waiting to try that.

If I always need to rmmod/modprobe everytime, that is meaning that
something is kept messed somewhere in memory and should be cleaned by
restart (reinitialize ?) the device.


Mohamed-Ikbel

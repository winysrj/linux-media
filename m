Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50324 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbZFCKKN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2009 06:10:13 -0400
Message-ID: <4A264BFB.3010901@redhat.com>
Date: Wed, 03 Jun 2009 12:10:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: libv4l release: 0.5.99 (The don't crash release)
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

So 0.5.98 had a few nasty bugs, causing black screens
and crashes in certain cases.

This release should fix all those.


libv4l-0.5.99
-------------
* Link libv4lconvert with -lm for powf by Gregor Jasny
* Fix black screen on devices with hardware gamma control
* Fix crash with devices on which we do not emulate fake controls
* Add a patch by Hans Petter Selasky <hselasky@freebsd.org>, which should
   lead to allowing use of libv4l (and the Linux webcam drivers ported
   to userspace usb drivers) on FreeBSD, this is a work in progress


Get it here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.99.tar.gz

Regards,

Hans


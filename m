Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:21840 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZFISUN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 14:20:13 -0400
Received: by rv-out-0506.google.com with SMTP id f9so69990rvb.1
        for <linux-media@vger.kernel.org>; Tue, 09 Jun 2009 11:20:13 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 9 Jun 2009 14:20:13 -0400
Message-ID: <18b102300906091120j656650a2mc9b9a09240926627@mail.gmail.com>
Subject: Green screen and barf with HP Webcam (15b8:6002)
From: James Klaas <jklaas@appalachian.dyndns.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been trying to get an HP webcam (usbid 15b8:6002) running on my
GFs machine.  She's running Ubuntu Hardy with 2.6.24-24-generic
kernel.  I downloaded the mercurial repo for v4l-dvb.  It compiled
without complaint and the modules load without complaint.  I've got it
running on Ubuntu Jaunty with 2.6.28-11-generic and it seems to work
fine.

I've been using Skype as my test platform.  I noticed on Jaunty that
Skype is now wrapped with the v4l1compat.so library, so I tried doing
that, but the results were the same.  Is there anything I can try
short of upgrading my distro or kernel?

James

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp105.rog.mail.re2.yahoo.com ([206.190.36.83]:32177 "HELO
	smtp105.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758656AbZAPB7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 20:59:36 -0500
Message-ID: <496FEA02.5090506@rogers.com>
Date: Thu, 15 Jan 2009 20:59:30 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Robert Krakora <rob.krakora@messagenetsystems.com>
CC: video4linux-list@redhat.com,
	Linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] em28xx: Fix audio URB transfer buffer memory leak
 and	race condition/corruption of capture pointer
References: <b24e53350901150637q5f02d2c5t6d4a9ed5d298934b@mail.gmail.com> <b24e53350901150911l4e90e2d8s52e6d357968bb129@mail.gmail.com>
In-Reply-To: <b24e53350901150911l4e90e2d8s52e6d357968bb129@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

I don't know if you're aware, but we've recently switched mailing lists
for which patches should be submitted (see Mauro's note:
http://www.linuxtv.org/news.php?entry=2009-01-06.mchehab) ... I've been
busy trying to update the likes of articles such as 
http://www.linuxtv.org/wiki/index.php/Development:_How_to_submit_patches 
that may have still contained instructions/links to the older mailing
lists.  Sorry for the inconvenience.  Unless Mauro, or a driver
maintainer has already picked them up, please resend them to the new list.

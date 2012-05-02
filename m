Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:51316 "EHLO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2EBLoh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 07:44:37 -0400
Date: Wed, 2 May 2012 13:44:30 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Paulo Assis <pj.assis@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: logitech quickcam 9000 uvcdynctrl broken since kernel 3.2 - PING
Message-ID: <20120502114430.GA4608@kipc2.localdomain>
References: <20120424122156.GA16769@kipc2.localdomain>
 <20120502084318.GA21181@kipc2.localdomain>
 <CAPueXH4-VSxHYjryO8kN5R-hG6seFrwCu3Kjrq4TXV=XFKLETg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPueXH4-VSxHYjryO8kN5R-hG6seFrwCu3Kjrq4TXV=XFKLETg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paulo,

I am running plain Fedora 16 on x86_64.

The last kernel where UVC dyncontrols worked was 3.1.10-2.
(If I remember correctly...) The first kernel with failing
dyncontrols was 3.2.1-1 and all later kernels up to 3.3.2-6
fail as well.

libwebcam version is libwebcam-0.2.0-4.20100322svn and guvcview
is guvcview-1.5.1-1.

http://www.quickcamteam.net/software/libwebcam seems to be offline/
discontinued since a few months.

what software versions are you running? Is there a later libwebcam
available from somewhere else?

pls look also at:
http://permalink.gmane.org/gmane.linux.kernel/1257500

Greetings,
Karl

On Wed 120502, Paulo Assis wrote:
> Karl Hi,
> I'm using a 3.2 kernel and I haven't notice this problem, can you
> check the exact version that causes it.
> 
> Regards,
> Paulo
> 

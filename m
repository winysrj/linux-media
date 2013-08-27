Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58382 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab3H0Jo0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 05:44:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VEFp3-0002yg-GE
	for linux-media@vger.kernel.org; Tue, 27 Aug 2013 11:44:25 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 27 Aug 2013 11:44:25 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 27 Aug 2013 11:44:25 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: Re: media-ctl: line 1: syntax error: 
Date: Tue, 27 Aug 2013 09:44:05 +0000 (UTC)
Message-ID: <loom.20130827T093740-834@post.gmane.org>
References: <loom.20130821T143312-331@post.gmane.org> <20130826214611.GC2835@valkosipuli.retiisi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus <sakari.ailus <at> iki.fi> writes:

Hello Sakari,

> You're missing single quotes around the argument to -l option. Looks like
> the string will reach media-ctl altogether w/o quotes and as several command
> line arguments, and both are bad. Entity names need to be quoted if they
> contain spaces.
> 


thanks for your reply. This solved my problem for now.

Best Regards, Tom


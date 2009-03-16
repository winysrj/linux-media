Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-6.mail.uk.tiscali.com ([212.74.114.14]:33300
	"EHLO mk-outboundfilter-6.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761617AbZCPXgc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 19:36:32 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: [RFC][PATCH 0/2] Sensor orientation reporting
Date: Mon, 16 Mar 2009 23:36:26 +0000
Cc: linux-media@vger.kernel.org, kilgota@banach.math.auburn.edu,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <200903152224.29388.linux@baker-net.org.uk> <49BE0709.9060300@hhs.nl>
In-Reply-To: <49BE0709.9060300@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903162336.27533.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 16 March 2009, Hans de Goede wrote:
> Both patches look good to me.

A complaint about lack of documentation wouldn't have gone amiss. 
Unfortunately having just remembered that I should have done that I'm 
struggling to get the current docbook to compile (So far I've suffered Ubuntu 
not packaging an old enough docbook, missing character set definition files 
and the Makefile depending on bash but not explicitly requesting it so 
getting dash).

It looks like it now builds the docs so I'm ready to start updating them.

Adam

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57609 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbZCDVNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 16:13:31 -0500
Date: Wed, 4 Mar 2009 18:13:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Pascal Terjan <pterjan@mandriva.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Arnaud Patard <apatard@mandriva.com>
Subject: Re: [hg:v4l-dvb] Add ids for Yuan PD378S DVB adapter
Message-ID: <20090304181320.099c56e0@pedra.chehab.org>
In-Reply-To: <1236196387.3606.2.camel@plop>
References: <E1LevhK-0006y8-4V@www.linuxtv.org>
	<1236196387.3606.2.camel@plop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Wed, 04 Mar 2009 20:53:07 +0100
Pascal Terjan <pterjan@mandriva.com> wrote:

> Le mercredi 04 mars 2009 à 19:20 +0100, Patch from Pascal Terjan a
> écrit :
> > The patch number 10825 was added via Mauro Carvalho Chehab <mchehab@redhat.com>
> > to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> The merge seems wrong:
> 
> > +/* 45 */{ USB_DEVICE(USB_VID_YUAN,      USB_PID_YUAN_PD378S) },
> 
> > +				{ &dib0700_usb_id_table[44], NULL },
> 
> Should be 45
> 

Fixed. Thanks!

-- 

Cheers,
Mauro

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:60020 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758516AbZFDQWK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Jun 2009 12:22:10 -0400
Date: Thu, 4 Jun 2009 18:22:01 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca: usb_set_interface() required for ISOC ep with altsetting
 of 0?
Message-ID: <20090604182201.12691aad@free.fr>
In-Reply-To: <4A280430.9030500@gmail.com>
References: <4A280430.9030500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 04 Jun 2009 19:28:16 +0200
Roel Kluin <roel.kluin@gmail.com> wrote:

> I noted that in get_ep() in drivers/media/video/gspca/gspca.c
> usb_set_interface() is not called for an ISOC endpoint with an
> altsetting of 0. Is that ok?

get_ep() has changed in the last releases. Now, usb_set_interface() is
called on (gspca_dev->nbalt > 1), i.e when there is more than one alternate setting.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

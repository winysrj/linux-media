Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50925 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1IWU0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 16:26:42 -0400
Received: by fxe4 with SMTP id 4so4171972fxe.19
        for <linux-media@vger.kernel.org>; Fri, 23 Sep 2011 13:26:40 -0700 (PDT)
Date: Fri, 23 Sep 2011 22:26:27 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Oliver Freyermuth <o.freyermuth@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Doychin Dokov <root@net1.cc>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Dominik Kuhlen <dkuhlen@gmx.net>,
	Andre Weidemann <Andre.Weidemann@web.de>,
	"Michael H. Schimek" <mschimek@gmx.at>
Subject: Re: [PATCH] Add support for PCTV452E.
Message-ID: <20110923222627.6893ab0c@grobi>
In-Reply-To: <4E7CE5F8.1050900@redhat.com>
References: <201105242151.22826.hselasky@c2i.net>
	<20110723132437.7b8add2c@grobi>
	<j43erv$8ft$1@dough.gmane.org>
	<4E7CE5F8.1050900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Sep 2011 17:03:04 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> > 
> > Attached is the 'new' version of the patch with the mentioned
> > changes.  
> 
> For it to be applied, we need the SOB's of the patch authors:
> 
> +MODULE_AUTHOR("Dominik Kuhlen <dkuhlen@gmx.net>");
> +MODULE_AUTHOR("Andre Weidemann <Andre.Weidemann@web.de>");
> +MODULE_AUTHOR("Michael H. Schimek <mschimek@gmx.at>");
> 
> Also, the patch needs some adjustments to be applied. See bellow for
> my quick review:

Another note - for the move of remote to rc-core (as suggested by
you) there is another patch waiting in your Inbox Mauro. 

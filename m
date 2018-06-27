Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49122 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932280AbeF0Ja6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 05:30:58 -0400
Date: Wed, 27 Jun 2018 12:30:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/8] media: imx274: add helper function to fill a
 reg_8 table chunk
Message-ID: <20180627093055.fn6gqpaodzxmhhx3@valkosipuli.retiisi.org.uk>
References: <1528716939-17015-1-git-send-email-luca@lucaceresoli.net>
 <1528716939-17015-7-git-send-email-luca@lucaceresoli.net>
 <20180626122053.gd5jmt2wr35s5oh2@valkosipuli.retiisi.org.uk>
 <fb7bb663-0708-8271-8f4a-fff906c7babc@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb7bb663-0708-8271-8f4a-fff906c7babc@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 27, 2018 at 10:13:12AM +0200, Luca Ceresoli wrote:
> Hi Sakari,
> 
> On 26/06/2018 14:20, Sakari Ailus wrote:
> > Hi Luca,
> > 
> > On Mon, Jun 11, 2018 at 01:35:37PM +0200, Luca Ceresoli wrote:
> >> Tables of struct reg_8 are used to simplify multi-byte register
> >> assignment. However filling these snippets with values computed at
> >> runtime is currently implemented by very similar functions doing the
> >> needed shift & mask manipulation.
> >>
> >> Replace all those functions with a unique helper function to fill
> >> reg_8 tables in a simple and clean way.
> > 
> > What's the purpose of writing these registers as multiple I²C writes, when
> > this can be done as a single write (i.e. the address followed by two or
> > three octets of data)?
> 
> Good point. The for loops applying the register values (the lines just
> after those changed by my patch) defuse the regmap bulk write capability.
> 
> I guess this could be improved not filling any table, but directly
> calling regmap_bulk_write(), passing the u16 or u32 register value with
> proper endianness. No tables, less code. This would replace the present
> patch with a shorter and more effective one. Is it what you was suggesting?

Yes, please.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi

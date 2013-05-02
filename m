Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:49483 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759463Ab3EBNmP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 09:42:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC v2] media: i2c: mt9p031: add OF support
Date: Thu, 02 May 2013 15:42:19 +0200
Message-ID: <3547278.d3Q4LvxEgy@wuerfel>
In-Reply-To: <20130502065518.GN32299@pengutronix.de>
References: <1367475754-19477-1-git-send-email-prabhakar.csengg@gmail.com> <20130502065518.GN32299@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 02 May 2013 08:55:18 Sascha Hauer wrote:
> > +#if defined(CONFIG_OF)
> > +static struct mt9p031_platform_data *
> > +     mt9p031_get_pdata(struct i2c_client *client)
> > +
> > +{
> > +     if (client->dev.of_node) {
> 
> By inverting the logic here and returning immediately you can safe an
> indention level for the bulk of this function.

Right, also make this

	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
		return client->dev.platform_data;

Then the rest of the function gets discarded by the compiler when CONFIG_OF
is not set, and you can kill the #ifdef around the function.

	Arnd

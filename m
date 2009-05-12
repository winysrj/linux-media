Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:56141 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbZELGKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 02:10:39 -0400
Subject: Re: [PATCH v2 4/7] FMTx: si4713: Add files to handle si4713 i2c
 device
From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Reply-To: ext-eero.nurkkala@nokia.com
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <1242105735.19944.62.camel@eenurkka-desktop>
References: <1242034309-13448-1-git-send-email-eduardo.valentin@nokia.com>
	 <1242034309-13448-2-git-send-email-eduardo.valentin@nokia.com>
	 <1242034309-13448-3-git-send-email-eduardo.valentin@nokia.com>
	 <1242034309-13448-4-git-send-email-eduardo.valentin@nokia.com>
	 <1242034309-13448-5-git-send-email-eduardo.valentin@nokia.com>
	 <1242105350.19944.56.camel@eenurkka-desktop>
	 <1242105735.19944.62.camel@eenurkka-desktop>
Content-Type: text/plain
Date: Tue, 12 May 2009 09:08:34 +0300
Message-Id: <1242108514.19944.64.camel@eenurkka-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-05-12 at 08:22 +0300, Eero Nurkkala wrote:
> > > +       /* Australia */
> > > +       {
> > > +               .channel_spacing        = 20,
> > > +               .bottom_frequency       = 8750,
> > > +               .top_frequency          = 10800,
> > > +               .preemphasis            = 1,
> > > +               .region                 = 1,
> > > +       },

Hi,

Australia must be 88.1 - 107.9 with 10 channel spacing.

- Eero


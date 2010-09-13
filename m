Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.233]:46025 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab0IMMBS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 08:01:18 -0400
Subject: Re: [PATCH v9 0/4] FM Radio driver.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
In-Reply-To: <201009131351.35487.hverkuil@xs4all.nl>
References: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <201009131332.15287.hverkuil@xs4all.nl>
	 <1284378271.12913.42.camel@masi.mnp.nokia.com>
	 <201009131351.35487.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 14:59:30 +0300
Message-ID: <1284379170.12913.50.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2010-09-13 at 13:51 +0200, ext Hans Verkuil wrote:
> On Monday, September 13, 2010 13:44:31 Matti J. Aaltonen wrote:
> > On Mon, 2010-09-13 at 13:32 +0200, ext Hans Verkuil wrote:
> > > > Anyway the difference between the "completely raw bits" and the "raw"
> > > > blocks is small. And I doubt the usefulness of supporting the
> > > > "completely raw" format.
> > > 
> > > I don't intend to support it now. But we need to realize that it exists and
> > > we have to plan for it.
> > 
> > OK. So we can have RDS_RAW_READWRITE and also RDS_RAW_BLOCK_READWRITE
> > (or something to the same effect)?
> 
> In theory, yes. My proposed API additions allow for this to be added in the
> future. Frankly, I don't think it is likely that it will be needed, but you
> never know.

Yes but I would like to add the RDS_RAW_BLOCK_READWRITE possibility
right away because that's what the wl1273 driver does now... I guess
that's OK?

B.R.
Matti

> 
> Regards,
> 
> 	Hans
> 
> > 
> > B.R.
> > Matti
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 



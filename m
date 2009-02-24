Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:24846 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbZBXGsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 01:48:02 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2944521wfa.4
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2009 22:48:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0902191616340.5156@axis700.grange>
References: <Pine.LNX.4.64.0902191615000.5156@axis700.grange>
	 <Pine.LNX.4.64.0902191616340.5156@axis700.grange>
Date: Tue, 24 Feb 2009 15:47:59 +0900
Message-ID: <aec7e5c30902232247x4a3e57celc82d4148fd7f045d@mail.gmail.com>
Subject: Re: [PATCH 2/2] soc-camera: configure drivers with a default format
	on open
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	morimoto.kuninori@renesas.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 20, 2009 at 12:20 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Currently soc-camera doesn't set up any image format without an explicit S_FMT.
> It seems this should be supported, since, for example, capture-example.c from
> v4l2-apps by default doesn't issue an S_FMT. This patch configures a default
> image format on open().
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---

I like the idea behind this patch, but I wonder if it is compatible
with standard V4L2 behaviour. Please double check against the  open()
comment in section "4.1.3. Image Format Negotiation" below:

http://v4l2spec.bytesex.org/spec/c6488.htm#AEN6520

Cheers,

/ magnus

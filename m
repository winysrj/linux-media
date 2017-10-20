Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:60924 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753252AbdJTQ7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 12:59:05 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pierre-Hugues Husson <phh@phh.me>,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] pinctrl: rockchip: Add iomux-route switching support for rk3288
Date: Fri, 20 Oct 2017 18:58:58 +0200
Message-ID: <40786265.ZDfztTY44U@diego>
In-Reply-To: <68b8765d-3d55-3fdd-e23e-776e978c38bd@xs4all.nl>
References: <20171013225337.5196-1-phh@phh.me> <2040825.vRYCsv903Y@diego> <68b8765d-3d55-3fdd-e23e-776e978c38bd@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, 20. Oktober 2017, 09:44:55 CEST schrieb Hans Verkuil:
> On 20/10/17 09:38, Heiko Stübner wrote:
> > Hi Hans,
> > 
> > Am Freitag, 20. Oktober 2017, 09:28:58 CEST schrieb Hans Verkuil:
> >> On 14/10/17 17:39, Heiko Stuebner wrote:
> >>> So far only the hdmi cec supports using one of two different pins
> >>> as source, so add the route switching for it.
> >>> 
> >>> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> >> 
> >> Just tested this on my firefly reload and it works great!
> >> 
> >> Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > oh cool. I really only wrote this based on the soc manual,
> > so it actually surprises me, that it works on the first try :-)
> 
> One note though: I've only tested it on my Firefly Reload. I don't have a
> regular Firefly, so I can't be certain it works there. Just covering my ass
> here :-)

Haha ... I guess the only thing I could have messed up would be the
ordering (valu0 -> gpio0, value1 -> gpio7 ... and reverse), so if it were
really wrong, you shouldn've have seen any results at all.

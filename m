Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:47352 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751213AbdJVHkz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Oct 2017 03:40:55 -0400
Subject: Re: [PATCH 0/4] arm: dts: rockchip: enable HDMI+CEC on Firefly Reload
To: linux-media@vger.kernel.org
References: <20171020100734.17064-1-hverkuil@xs4all.nl>
Cc: linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2d624a0f-ff2c-7d18-3e13-ff5f766bf5c8@xs4all.nl>
Date: Sun, 22 Oct 2017 09:40:53 +0200
MIME-Version: 1.0
In-Reply-To: <20171020100734.17064-1-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Heiko,

On 20/10/17 12:07, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series sits on top of these two patch series:
> 
> https://lkml.org/lkml/2017/10/13/971
> https://lkml.org/lkml/2017/10/14/161
> 
> The first adds support for the cec clk in dw-hdmi, the second adds an
> iomux-route for the CEC pin on the rk3288.
> 
> This patch series defines the cec clk for the rk3288, enables the
> first HDMI output on the Firefly Reload. The second output isn't working,
> I don't have enough knowledge to enable it. But I can test any patches
> adding support for it!
> 
> The third patch defines the two possible CEC pins and the last selects
> the correct pin for the Firefly Reload.
> 
> Likely the same thing can be done for the 'regular' Firefly, but I don't
> have the hardware to test.

My Firefly Reload thanks you for merging this series! :-)

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38335 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbaKQOh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 09:37:26 -0500
Message-ID: <546A0818.9060504@xs4all.nl>
Date: Mon, 17 Nov 2014 15:37:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jean-Marc VOLLE <jean-marc.volle@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Divneil Rai WADHAWAN <divneil.wadhawan@st.com>
Subject: Re: [PATCH] ITU BT2020 support in v4l2_colorspace
References: <1406905371-17609-1-git-send-email-jean-marc.volle@st.com>
In-Reply-To: <1406905371-17609-1-git-send-email-jean-marc.volle@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/01/2014 05:02 PM, Jean-Marc VOLLE wrote:
> From: vollejm <jean-marc.volle@st.com>
> 
> UHD video content may be encoded using a new color space (BT2020). This patch
> adds it to the  v4l2_colorspace enum

FYI: I've just posted a patch series that enhances V4L2 colorspace support to
include BT.2020 (among others).

See: http://www.mail-archive.com/linux-media@vger.kernel.org/msg81883.html

Regards,

	Hans

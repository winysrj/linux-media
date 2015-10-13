Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33288 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbbJMWwI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2015 18:52:08 -0400
Date: Tue, 13 Oct 2015 23:51:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv9 07/15] cec: add HDMI CEC framework
Message-ID: <20151013225147.GM32532@n2100.arm.linux.org.uk>
References: <cover.1441633456.git.hansverk@cisco.com>
 <60de2f33f0d4c809f06d23cdac75e3b798aaae4b.1441633456.git.hansverk@cisco.com>
 <20151006170635.GQ21513@n2100.arm.linux.org.uk>
 <561B9B1A.4020001@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <561B9B1A.4020001@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2015 at 01:35:54PM +0200, Hans Verkuil wrote:
> On 10/06/2015 07:06 PM, Russell King - ARM Linux wrote:
> > Surely you aren't proposing that drivers should write directly to
> > adap->phys_addr without calling some notification function that the
> > physical address has changed?
> 
> Userspace is informed through CEC_EVENT_STATE_CHANGE when the adapter is
> enabled/disabled. When the adapter is enabled and CEC_CAP_PHYS_ADDR is
> not set (i.e. the kernel takes care of this), then calling CEC_ADAP_G_PHYS_ADDR
> returns the new physical address.

Okay, so when I see the EDID arrive, I should be doing:

                phys = parse_hdmi_addr(block->edid);
                cec->adap->phys_addr = phys;
                cec_enable(cec->adap, true);

IOW, you _are_ expecting adap->phys_addr to be written, but only while
the adapter is disabled?

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.

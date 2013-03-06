Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:26005 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3CFKDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 05:03:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: volokh84@gmail.com
Subject: Re: tw2804.c
Date: Wed, 6 Mar 2013 11:02:47 +0100
Cc: linux-media@vger.kernel.org
References: <20130305194828.8A75511E00AE@alastor.dyndns.org> <20130306094813.GA1888@VPir.1>
In-Reply-To: <20130306094813.GA1888@VPir.1>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303061102.47933.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 6 March 2013 10:48:13 volokh84@gmail.com wrote:
> Hi,
> Hans
> 
> I found in d8077d2df184f3ef63ed9ff4579d41ca64e12855 commit,
> that V4L2_CTRL_FLAG_VOLATILE flag was disabled for some STD controls
> and fully disabled g_ctrl iface. So How can userspace know about changing some values?

VOLATILE is used when register values can change automatically (e.g. if
autogain is on and the device regulates the gain and updates that gain
register itself).

However, testing proved that the hardware doesn't update anything when
in autogain mode, hence volatile support isn't needed.

Note that the control framework always caches the last control value,
so to get non-volatile controls the framework just returns that cached
value.

Regards,

	Hans

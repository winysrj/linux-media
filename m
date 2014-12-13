Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35402 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbaLMQPN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 11:15:13 -0500
Message-ID: <548C6607.10700@collabora.com>
Date: Sat, 13 Dec 2014 11:15:03 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: LibV4L2 and CREATE_BUFS issues
References: <5488748B.7060703@collabora.com> <548C17C9.2060809@redhat.com>
In-Reply-To: <548C17C9.2060809@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-12-13 05:41, Hans de Goede a écrit :
> I think making CREATE_BUFS fail when doing conversion is probably best,
> note that gstreamer should be able to tell which formats will lead to 
> doing
> conversion, and that it can try to avoid those. 

Those format indeed have a flag. The problem is for HW specific format, 
like few bayers format, which we can't avoid if we need to use such camera.

cheers,
Nicolas

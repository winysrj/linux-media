Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:43914 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919Ab2BRRxr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Feb 2012 12:53:47 -0500
MIME-Version: 1.0
In-Reply-To: <4F3EADAA.9090702@redhat.com>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com>
	<1654816.MX2JJ87BEo@avalon>
	<1775349.d0yvHiVdjB@avalon>
	<4F3EADAA.9090702@redhat.com>
Date: Sat, 18 Feb 2012 11:53:45 -0600
Message-ID: <CAO8GWqk8ETrYT7VKL2Mdis3-6iYo8rkeEJObYXTngXDH=HzjAA@mail.gmail.com>
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC
 2012 - Notes
From: "Clark, Rob" <rob@ti.com>
To: Adam Jackson <ajax@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-fbdev@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osciak <pawel@osciak.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Alexander Deucher <alexander.deucher@amd.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 17, 2012 at 1:42 PM, Adam Jackson <ajax@redhat.com> wrote:
> On 2/16/12 6:25 PM, Laurent Pinchart wrote:
>
>>   Helper functions will be implemented in the subsystems to convert
>> between
>>   that generic structure and the various subsystem-specific structures.
>
>
> I guess.  I don't really see a reason not to unify the structs too, but then
> I don't have binary blobs to pretend to be ABI-compatible with.
>

this is just for where timing struct is exposed to userspace

BR,
-R

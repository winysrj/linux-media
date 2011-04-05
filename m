Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46267 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1DEMLR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:11:17 -0400
Received: by wwa36 with SMTP id 36so369183wwa.1
        for <linux-media@vger.kernel.org>; Tue, 05 Apr 2011 05:11:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D90854C.2000802@maxwell.research.nokia.com>
References: <4D90854C.2000802@maxwell.research.nokia.com>
Date: Tue, 5 Apr 2011 15:11:15 +0300
Message-ID: <BANLkTik9vSSRKYHj9cUGUzxFy_cpcVo7ZQ@mail.gmail.com>
Subject: Re: [RFC] V4L2 API for flash devices
From: David Cohen <dacohen@gmail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Mar 28, 2011 at 3:55 PM, Sakari Ailus
<sakari.ailus@maxwell.research.nokia.com> wrote:
> Hi,

Hi Sakari,

[snip]

> This is a bitmask containing the fault information for the flash. This
> assumes the proposed V4L2 bit mask controls [5]; otherwise this would
> likely need to be a set of controls.
>
> #define V4L2_FLASH_FAULT_OVER_VOLTAGE           0x00000001
> #define V4L2_FLASH_FAULT_TIMEOUT                0x00000002
> #define V4L2_FLASH_FAULT_OVER_TEMPERATURE       0x00000004
> #define V4L2_FLASH_FAULT_SHORT_CIRCUIT          0x00000008

Sorry for bringing this a bit late.  As we already talked directly,
IMO (1 << 0), (1 << 1), ... could have a better readability to expose
how you want to define an expand these macros.

Br,

David Cohen

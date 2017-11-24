Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14327 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752278AbdKXIzP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 03:55:15 -0500
Date: Fri, 24 Nov 2017 10:55:12 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: Re: notifier is skipped in some situations
Message-ID: <20171124085511.pehj5kwvykpzc25a@paasikivi.fi.intel.com>
References: <CAFLEztQg2R0oLcSfRKsQGFWTC1pTzPVqoksdKtGAYEYV6nAf9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLEztQg2R0oLcSfRKsQGFWTC1pTzPVqoksdKtGAYEYV6nAf9A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

On Fri, Nov 24, 2017 at 09:00:14AM +0800, Jacob Chen wrote:
> Hi Sakari,
> 
> I encountered a problem when using async sub-notifiers.
> 
> It's like that:
>     There are two notifiers, and they are waiting for one subdev.
>     When this subdev is probing, only one notifier is completed and
> the other one is skipped.

Do you have a graph that has two master drivers (that register the
notifier) and both are connected to the same sub-device? Could you provide
exact graph you have?

> 
> I found that in v15 of patch "v4l: async: Allow binding notifiers to
> sub-devices", "v4l2_async_notifier_complete" is replaced by
> v4l2_async_notifier_call_complete, which make it only complete one
> notifier.
> 
> Why is it changed? Can this be fixed?

-- 
Sakari Ailus
sakari.ailus@linux.intel.com

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24047 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752596AbdDKMTo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 08:19:44 -0400
Subject: Re: [PATCHv4 00/15] R-Car VSP1 Histogram Support
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170410192651.18486-1-hverkuil@xs4all.nl>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <339dde77-0b24-ad46-4008-3aa64fd9efc1@linux.intel.com>
Date: Tue, 11 Apr 2017 15:19:41 +0300
MIME-Version: 1.0
In-Reply-To: <20170410192651.18486-1-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/17 22:26, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series is the rebased version of this pull request:
> 
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg111025.html
> 
> It slightly modifies 'Add metadata buffer type and format' (remove
> experimental note and add newline after label) and it adds support
> for V4L2_CTRL_FLAG_MODIFY_LAYOUT, as requested by Mauro.
> 
> No other changes were made.

For patches 11--15:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com

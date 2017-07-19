Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0079.outbound.protection.outlook.com ([104.47.41.79]:65476
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755001AbdGSOvO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 10:51:14 -0400
Date: Wed, 19 Jul 2017 07:51:09 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4l2-utils] v4l2-ctl: Print numerical control ID
Message-ID: <20170719145109.g3dhhkcilsgyy3vz@xsjsorenbubuntu.xilinx.com>
References: <20170623135612.23922-1-soren.brinkmann@xilinx.com>
 <f3eeb34b-3d7d-d47c-d8a8-b7b6d15d55fb@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3eeb34b-3d7d-d47c-d8a8-b7b6d15d55fb@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-07-19 at 12:26:18 +0200, Hans Verkuil wrote:
> On 23/06/17 15:56, Soren Brinkmann wrote:
> > Print the numerical ID for each control in list commands.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > I was trying to set controls from a userspace application and was hence looking
> > for an easy way to find the control IDs to use with VIDIOC_(G|S)_EXT_CTRLS. The
> > -l/-L options of v4l2-ctl already provide most information needed, hence I
> > thought I'd add the numerical ID too.
> 
> Good idea. I applied the patch but with two small changes:
> 
> 1) I replaced qmenu.id by queryctrl->id to be more consistent.
> 2) I replaced the '/' separator by a space. It made the output a bit more readable IMHO.

Sounds good to me. Thanks!

	Sören

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:38366 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755553AbeCSPqE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 11:46:04 -0400
Subject: Re: [PATCH 0/8] media: fix more inconsistencies
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
References: <20180319154324.37799-1-hverkuil@xs4all.nl>
Message-ID: <7a2247bc-7db3-140a-90e4-f33e00360b67@xs4all.nl>
Date: Mon, 19 Mar 2018 16:45:59 +0100
MIME-Version: 1.0
In-Reply-To: <20180319154324.37799-1-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2018 04:43 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This is a follow-up of my earlier "media: fix inconsistencies"
> patch series (https://www.mail-archive.com/linux-media@vger.kernel.org/msg127943.html).
> 
> The purpose of this series is to expose the same information through
> the old and new MC APIs. There is no reason not to do this and it is
> frankly insane that some information is available through one API
> and not the other and vice versa.
> 
> The new API should be a superset of the old one.
> 
> This series also adds the 'function' field to the old API for the simple
> reason that you need this even today, otherwise you are unable to
> correctly identify the function of a subdev if it is one of the newer
> functions.

Note: the 'HAS' macros assume this will land in 4.17, which is
probably too optimistic. So if this slips to 4.18, then they need to
be updated.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> Hans Verkuil (8):
>   media-ioc-g-topology.rst: fix 'reserved' sizes
>   media: add function field to struct media_entity_desc
>   media-ioc-enum-entities.rst: document new 'function' field
>   media: add 'index' to struct media_v2_pad
>   media-ioc-g-topology.rst: document new 'index' field
>   media: add flags field to struct media_v2_entity
>   media-ioc-g-topology.rst: document new 'flags' field
>   media-types.rst: rename media-entity-type to media-entity-functions
> 
>  .../uapi/mediactl/media-ioc-enum-entities.rst      | 33 +++++++++++++++++-----
>  .../media/uapi/mediactl/media-ioc-g-topology.rst   | 29 ++++++++++++++++---
>  Documentation/media/uapi/mediactl/media-types.rst  |  4 +--
>  drivers/media/media-device.c                       |  3 ++
>  include/uapi/linux/media.h                         | 21 ++++++++++++--
>  5 files changed, 74 insertions(+), 16 deletions(-)
> 

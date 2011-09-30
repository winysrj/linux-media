Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1I3QyR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 12:54:17 -0400
Message-ID: <4E85F429.9060306@redhat.com>
Date: Fri, 30 Sep 2011 13:54:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi
Subject: Re: [PATCH 2/5] doc: v4l: add binary images for selection API
References: <1317306161-23696-1-git-send-email-t.stanislaws@samsung.com> <1317306161-23696-3-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1317306161-23696-3-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 29-09-2011 11:22, Tomasz Stanislawski escreveu:
> This patch adds images in binary format for the V4L2 selection API.

Please, just fold with the docbook patch on a next submission. Also, please
put the docbook patch at the beginning of the series, since this is the most
important patch on this series, as the other ones can only be understandable
after reading the docbook.

Thanks!
Mauro
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/constraints.png.b64 |  134 +
>  Documentation/DocBook/media/selection.png.b64   | 2937 +++++++++++++++++++++++
>  2 files changed, 3071 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/DocBook/media/constraints.png.b64
>  create mode 100644 Documentation/DocBook/media/selection.png.b64
> 



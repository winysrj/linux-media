Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:56886 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750868AbeBDNqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Feb 2018 08:46:24 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: MEDIA_IOC_G_TOPOLOGY and entity flags
Message-ID: <7fa6b2e0-93d9-1495-f088-d1a05d343092@xs4all.nl>
Date: Sun, 4 Feb 2018 14:46:20 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Another thing that is missing in the G_TOPOLOGY ioctl are the entity flags
MEDIA_ENT_FL_DEFAULT and MEDIA_ENT_FL_CONNECTOR.

The DEFAULT flag should be part of the interface flags (it describes which
interface is the default). The CONNECTOR flag should be a new field in the
media_v2_entity struct. In theory it is possible to deduce this from the
entity ID, but I think that's a bad idea.

I'm not sure if the DEFAULT flag would also make sense for an entity as
opposed to an interface. I don't think so.

Regards,

	Hans

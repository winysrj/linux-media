Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:45282 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbbHSLM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 07:12:28 -0400
Message-ID: <55D46401.7080503@xs4all.nl>
Date: Wed, 19 Aug 2015 13:09:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 2/8] [media] media: add a common struct to be embed
 on media graph objects
References: <cover.1439981515.git.mchehab@osg.samsung.com> <0622f35fe1287a61f7703ba3f99fd78e4f992806.1439981515.git.mchehab@osg.samsung.com>
In-Reply-To: <0622f35fe1287a61f7703ba3f99fd78e4f992806.1439981515.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/15 13:01, Mauro Carvalho Chehab wrote:
> Due to the MC API proposed changes, we'll need to have an unique
> object ID for all graph objects, and have some shared fields
> that will be common on all media graph objects.
> 
> Right now, the only common object is the object ID, but other
> fields will be added later on.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

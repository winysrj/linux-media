Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50033 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab0BCAQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 19:16:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH] uvcvideo: check minimum border of control
Date: Wed, 3 Feb 2010 01:17:28 +0100
Cc: V4L Mailing List <linux-media@vger.kernel.org>
References: <4B5F60B0.7090709@freemail.hu>
In-Reply-To: <4B5F60B0.7090709@freemail.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002030117.28362.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Márton,


On Tuesday 26 January 2010 22:37:52 Németh Márton wrote:
> Check also the minimum border of a value before setting it
> to a control value.
> 
> See also http://bugzilla.kernel.org/show_bug.cgi?id=12824 .
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

I've updated the previous patch in the uvcvideo git repository, could you 
please test it ? 

-- 
Regards,

Laurent Pinchart

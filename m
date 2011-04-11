Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56081 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab1DKJIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 05:08:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?iso-8859-15?q?Lo=EFc_Akue?= <akue.loic@gmail.com>
Subject: Re: Media entity configuration
Date: Mon, 11 Apr 2011 11:08:24 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <BANLkTi=J+58gOeFtZ9LZa+OgfX93PQnmNw@mail.gmail.com> <201104111038.03673.laurent.pinchart@ideasonboard.com> <BANLkTi=teLgzOg=PRHXhLx+_9cBTUV_Pfg@mail.gmail.com>
In-Reply-To: <BANLkTi=teLgzOg=PRHXhLx+_9cBTUV_Pfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104111108.25044.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Loïc.

On Monday 11 April 2011 10:49:26 Loïc Akue wrote:
> Hi,
> 
> Sorry for the lack of informations.
> 
> This the pipeline configuration I want :[TVP5154 subdev] ==> [CCDC INPUT]
> ==> [CCDC OUTPUT : /dev/video2],
> And all the pad formats should be set to Y8 format.
> 
> I'd like this to be done à startup, so I can directly use yavta for
> example.

Just run media-ctl at startup to configure the pipeline.

-- 
Regards,

Laurent Pinchart

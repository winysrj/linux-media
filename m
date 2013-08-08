Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:2265 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3HHLcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 07:32:55 -0400
From: =?ISO-8859-1?Q?B=E5rd?= Eirik Winther <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: hansverk@cisco.com
Subject: Re: [git:v4l-utils/master] qv4l2: add aspect ratio support
Date: Thu, 08 Aug 2013 13:32:51 +0200
Message-ID: <2733966.NUgGszmazj@bwinther>
In-Reply-To: <E1V7L76-0005aC-HM@www.linuxtv.org>
References: <E1V7L76-0005aC-HM@www.linuxtv.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

Bad news. While rebasing my cropping support branch I noticed that Hans has merged in the wrong patch series for the scaling.

The one Hans have merged is one of our internal revisions, as only v1 is present on the mailing list.
I sent out a full patch series on Tuesday that consists of 9 parts, wheras the part you have merged is only 7 (from YUY2 shader to aspect ratio).

B.

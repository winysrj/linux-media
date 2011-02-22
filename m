Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:54069 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1BVPQn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 10:16:43 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 70CFB189B7F
	for <linux-media@vger.kernel.org>; Tue, 22 Feb 2011 16:16:38 +0100 (CET)
Date: Tue, 22 Feb 2011 16:16:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [Q] {enum,s,g}_input for subdev ops
Message-ID: <Pine.LNX.4.64.1102221612380.1380@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

Any thoughts about the subj? Hasn't anyone run into a need to select 
inputs on subdevices until now? Something like

struct v4l2_subdev_video_ops {
	...
	int (*enum_input)(struct v4l2_subdev *sd, struct v4l2_input *inp);
	int (*g_input)(struct v4l2_subdev *sd, unsigned int *i);
	int (*s_input)(struct v4l2_subdev *sd, unsigned int i);

For example, we discussed implementing sensor test patterns as separate 
inputs.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

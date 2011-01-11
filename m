Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2156 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab1AKXG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 18:06:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Alberto Panizzo <maramaopercheseimorto@gmail.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Marek Vasut <marek.vasut@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH 00/12] Converting soc_camera to the control framework
Date: Wed, 12 Jan 2011 00:06:00 +0100
Message-Id: <1294787172-13638-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The control framework was created to make it easier to implement the full
control API in drivers. Documentation can be found in:

Documentation/video4linux/v4l2-controls.txt

Traditionally soc-camera used its own control implementation to allow the
inheritance of controls from subdevices. The control handler does this as
well but in a generic, non-soc_camera specific, manner.

This patch series converts all soc_camera drivers that have controls to
the control framework. This brings us one more step closer to being able
to reuse soc_camera subdevs in other environments.

This has been tested on a Renesas sh-mobile board (thanks Magnus!).

These patches are also available in my git tree:

http://git.linuxtv.org/hverkuil/media_tree.git?a=shortlog;h=refs/heads/soc_camera

The goal is to get this patch series merged for 2.6.39.

It would be great if people who have boards with sensors affected by this
patch series can test this.

Regards,

	Hans


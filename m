Return-path: <mchehab@gaivota>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43621 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab1EJOOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2011 10:14:33 -0400
Received: by gyd10 with SMTP id 10so2143493gyd.19
        for <linux-media@vger.kernel.org>; Tue, 10 May 2011 07:14:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinBmoeuPBfwNL2z62xLhzZK_owM1Q@mail.gmail.com>
References: <BANLkTi=pS07RymXLOFsRihd5Jso-y6OsHg@mail.gmail.com>
	<BANLkTinrSz4nULGS729jEhs1O=wvUy19Jg@mail.gmail.com>
	<BANLkTincAieXM+DNbkaHiRVxEA6nh6O0Tw@mail.gmail.com>
	<201105101425.40631.laurent.pinchart@ideasonboard.com>
	<BANLkTinBmoeuPBfwNL2z62xLhzZK_owM1Q@mail.gmail.com>
Date: Tue, 10 May 2011 16:14:09 +0200
Message-ID: <BANLkTin9GKVUfzr+oZSMetzRVo2ENquKqQ@mail.gmail.com>
Subject: Re: Current status report of mt9p031.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris Rodley <carlighting@yahoo.co.nz>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Laurent,
information for data lane shifter is passed through platform data:

/**
 * struct isp_parallel_platform_data - Parallel interface platform data
 * @data_lane_shift: Data lane shifter
 *		0 - CAMEXT[13:0] -> CAM[13:0]
 *		1 - CAMEXT[13:2] -> CAM[11:0]
 *		2 - CAMEXT[13:4] -> CAM[9:0]
 *		3 - CAMEXT[13:6] -> CAM[7:0]
 * @clk_pol: Pixel clock polarity
 *		0 - Non Inverted, 1 - Inverted
 * @bridge: CCDC Bridge input control
 *		ISPCTRL_PAR_BRIDGE_DISABLE - Disable
 *		ISPCTRL_PAR_BRIDGE_LENDIAN - Little endian
 *		ISPCTRL_PAR_BRIDGE_BENDIAN - Big endian
 */
struct isp_parallel_platform_data {
	unsigned int data_lane_shift:2;
	unsigned int clk_pol:1;
	unsigned int bridge:4;
};

This way I am able to convert from 12bpp to 8bpp:
data_lane_shift = 2  and  bridge = ISPCTRL_PAR_BRIDGE_DISABLE

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com

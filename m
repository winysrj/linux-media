Return-path: <mchehab@pedra>
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:41113 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab1CAHZp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 02:25:45 -0500
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 1 Mar 2011 15:25:12 +0800
Subject: isp or soc-camera for image co-processors
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384DEFA5983D@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi and Laurent,

We are now evaluating another ST platform that supports a image
co-processor between the camera sensor and the camera host (SoC).

The simple architecture diagram will be similar to one shown below
(for the sake of simplicity I show only a single sensor. At least 
two sensors can be supported by the co-processor):

----------------CSI-2 interface   	------------------------ CSI2 interface	------------------
|Camera sensor |<--------------->	|CSI2			CSI2	|<-------=------>	|SoC (ARM Based)	|
|    0         |				|serial		serial|			|			|
|		   |				|receiver	transmitter	|			|			|
|		   |CCI Interface		|				|			|			|
|	         |<--------------->	|CCI			CCI	|CCI/I2C Interface|			|
|              |				|master		slave	|<-------------->	|			|
----------------				|				|			|			|
						|				|SYNC signals	|			|
						|	         	ITU	|---------------> |			| 
						|              	CCIR	|Pixel CLK		|		   	|
						|		   Interface|--------------->	|          		|
						|	         		|ITU Data		|		  	|
						|              		|--------------->	|		   	|
						|Image	   video	|			|          		|
						|Processor    processing|			|		   	|
						|			logic	|			|			|
						-------------------------			-------------------

The co-processor supports a video progressing logic engine capable of
performing a variety of operations like image recovery, cropping, scaling,
gamma correction etc.

Now, evaluating the framework available for supporting for the camera
host, sensor and co-processor, I am wondering whether soc-camera(v4l2) can
support this complex design or something similar to the ISP driver written
for OMAP is the way forward.

Any pointers on the same and reference links to some documentation
will be highly appreciated.

Thanks for your help,
Regards,
Bhupesh
ST Microelectonics

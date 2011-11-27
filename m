Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:52077 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751196Ab1K0KMl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 05:12:41 -0500
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-media@vger.kernel.org
Subject: Re: Status of RTL283xU support? [NOXON DAB Stick Supported][PATCH for 3.2 included]
Date: Sun, 27 Nov 2011 11:12:33 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111271112.33964.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 26, 2011 at 13:47, Maik Zumstrull <maik@xxxxxxxxxxxxx> wrote:
>
> > it seems I've found myself with an rtl2832u-based DVB-T USB stick. The
> > latest news on that seems to be that you were working on cleaning up
> > the code of the Realtek-provided GPL driver, with the goal of
> > eventually getting it into mainline.
> >
> > Would you mind giving a short status update?
>
> FYI, someone has contacted me off-list to point out that the newest(?)
> Realtek tree for these devices is available online:
>
> Alessandro Ambrosini wrote:
>
> > Dear maik,
> >
> > I've read your post here
> > http://www.mail-archive.com/linux-media@xxxxxxxxxxxxxxx/msg39559.html
> > I have not a subscription to linux-media mailing list. I see your post
> > looking for in archive.
> >
> > Some days ago I've asked to Realtek if there are newer driver (latest on 
the
> > net was 2.2.0)
> > They kindly send me latest driver 2.2.2 kernel 2.6.x
> >
> > I've patched it yesterday for kernel 3.0.0 (Ubuntu 11.10) and they looks 
to
> > work fine.
> > I'm not an expert C coder, only an hobbyist. So I suppose there are
> > problems.
> >
> > Anyway here you can find:
> >
> > 1) original Realtek 2.2.2 driver "simplified version" (DVB-T only and 4
> > tuners only)
> > https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-4_tuner
> >
> > 2) original Realtek 2.2.2 driver "full version" (DVB-T/ DTMB and 10 
tuners)
> > https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-10_tuner
> >
> > 3) driver "full" modded by me for kernel 3.0.0
> > https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-10tuner-
mod_kernel-3.0.0
> > README file explain about all
...

Please note that the DVB part of the Noxon DAB Stick (USB ID 0ccd:00b3) is 
also supported by the driver code (not sure how to access DAB+, maybe someone 
can give me a hint?)!

For kernel 3.2 the following patch is required (tested with 3.2-rc2 64bit 
kernel), relative to the "full" modded kernel 3.0.0 version from Alessandro:

--- a/rtl2832u.c	2011-11-27 11:05:03.587543422 +0100
+++ b/rtl2832u.c	2011-11-27 10:47:19.329713097 +0100
@@ -689,7 +689,11 @@ error:
 
 static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+	adap->fe_adap[0].fe = rtl2832u_fe_attach(adap->dev);
+#else
 	adap->fe = rtl2832u_fe_attach(adap->dev);
+#endif
 	return 0;
 }
 
@@ -835,9 +839,16 @@ static struct dvb_usb_device_properties
 	.adapter =
 	{
 		{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		.fe_ioctl_override = rtl2832u_ioctl_override,
+		.num_frontends = 1,
+		.fe = {{
+#endif
 			.streaming_ctrl = rtl2832u_streaming_ctrl,
 			.frontend_attach = rtl2832u_frontend_attach,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)
 			.fe_ioctl_override = rtl2832u_ioctl_override,
+#endif
 			//parameter for the MPEG2-data transfer
 			.stream =
 			{
@@ -852,6 +863,9 @@ static struct dvb_usb_device_properties
 					}
 				}
 			},
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		}},
+#endif
 		}
 	},
 
@@ -917,9 +931,16 @@ static struct dvb_usb_device_properties
 	.adapter =
 	{
 		{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		.fe_ioctl_override = rtl2832u_ioctl_override,
+		.num_frontends = 1,
+		.fe = {{
+#endif
 			.streaming_ctrl = rtl2832u_streaming_ctrl,
 			.frontend_attach = rtl2832u_frontend_attach,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)
 			.fe_ioctl_override = rtl2832u_ioctl_override,
+#endif
 			//parameter for the MPEG2-data transfer
 			.stream =
 			{
@@ -934,6 +955,9 @@ static struct dvb_usb_device_properties
 					}
 				}
 			},
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		}},
+#endif
 		}
 	},
 	//remote control
@@ -999,9 +1023,16 @@ static struct dvb_usb_device_properties
 	.adapter =
 	{
 		{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		.fe_ioctl_override = rtl2832u_ioctl_override,
+		.num_frontends = 1,
+		.fe = {{
+#endif
 			.streaming_ctrl = rtl2832u_streaming_ctrl,
 			.frontend_attach = rtl2832u_frontend_attach,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)
 			.fe_ioctl_override = rtl2832u_ioctl_override,
+#endif
 			//parameter for the MPEG2-data transfer
 			.stream =
 			{
@@ -1016,6 +1047,9 @@ static struct dvb_usb_device_properties
 					}
 				}
 			},
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		}},
+#endif
 		}
 	},
 
@@ -1087,9 +1121,16 @@ static struct dvb_usb_device_properties
 	.adapter =
 	{
 		{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		.fe_ioctl_override = rtl2832u_ioctl_override,
+		.num_frontends = 1,
+		.fe = {{
+#endif
 			.streaming_ctrl = rtl2832u_streaming_ctrl,
 			.frontend_attach = rtl2832u_frontend_attach,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)
 			.fe_ioctl_override = rtl2832u_ioctl_override,
+#endif
 			//parameter for the MPEG2-data transfer
 			.stream =
 			{
@@ -1104,6 +1145,9 @@ static struct dvb_usb_device_properties
 					}
 				}
 			},
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		}},
+#endif
 		}
 	},
 	//remote control
@@ -1176,9 +1220,16 @@ static struct dvb_usb_device_properties
 	.adapter =
 	{
 		{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		.fe_ioctl_override = rtl2832u_ioctl_override,
+		.num_frontends = 1,
+		.fe = {{
+#endif
 			.streaming_ctrl = rtl2832u_streaming_ctrl,
 			.frontend_attach = rtl2832u_frontend_attach,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)
 			.fe_ioctl_override = rtl2832u_ioctl_override,
+#endif
 			//parameter for the MPEG2-data transfer
 			.stream =
 			{
@@ -1193,6 +1244,9 @@ static struct dvb_usb_device_properties
 					}
 				}
 			},
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		}},
+#endif
 		}
 	},
 	//remote control
@@ -1265,9 +1319,16 @@ static struct dvb_usb_device_properties
 	.adapter =
 	{
 		{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		.fe_ioctl_override = rtl2832u_ioctl_override,
+		.num_frontends = 1,
+		.fe = {{
+#endif
 			.streaming_ctrl = rtl2832u_streaming_ctrl,
 			.frontend_attach = rtl2832u_frontend_attach,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)
 			.fe_ioctl_override = rtl2832u_ioctl_override,
+#endif
 			//parameter for the MPEG2-data transfer
 			.stream =
 			{
@@ -1282,6 +1343,9 @@ static struct dvb_usb_device_properties
 					}
 				}
 			},
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		}},
+#endif
 		}
 	},
 	 /*remote control*/
@@ -1353,9 +1417,16 @@ static struct dvb_usb_device_properties
 	.adapter =
 	{
 		{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		.fe_ioctl_override = rtl2832u_ioctl_override,
+		.num_frontends = 1,
+		.fe = {{
+#endif
 			.streaming_ctrl = rtl2832u_streaming_ctrl,
 			.frontend_attach = rtl2832u_frontend_attach,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)
 			.fe_ioctl_override = rtl2832u_ioctl_override,
+#endif
 			//parameter for the MPEG2-data transfer
 			.stream =
 			{
@@ -1370,6 +1441,9 @@ static struct dvb_usb_device_properties
 					}
 				}
 			},
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		}},
+#endif
 		}
 	},
 	//remote control
@@ -1436,9 +1510,16 @@ static struct dvb_usb_device_properties
 	.adapter =
 	{
 		{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		.fe_ioctl_override = rtl2832u_ioctl_override,
+		.num_frontends = 1,
+		.fe = {{
+#endif
 			.streaming_ctrl = rtl2832u_streaming_ctrl,
 			.frontend_attach = rtl2832u_frontend_attach,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)
 			.fe_ioctl_override = rtl2832u_ioctl_override,
+#endif
 			//parameter for the MPEG2-data transfer
 			.stream =
 			{
@@ -1453,6 +1534,9 @@ static struct dvb_usb_device_properties
 					}
 				}
 			},
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		}},
+#endif
 		}
 	},
 	//remote control
@@ -1519,9 +1603,16 @@ static struct dvb_usb_device_properties
 	.adapter =
 	{
 		{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		.fe_ioctl_override = rtl2832u_ioctl_override,
+		.num_frontends = 1,
+		.fe = {{
+#endif
 			.streaming_ctrl = rtl2832u_streaming_ctrl,
 			.frontend_attach = rtl2832u_frontend_attach,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)
 			.fe_ioctl_override = rtl2832u_ioctl_override,
+#endif
 			//parameter for the MPEG2-data transfer
 			.stream =
 			{
@@ -1536,6 +1627,9 @@ static struct dvb_usb_device_properties
 					}
 				}
 			},
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)
+		}},
+#endif
 		}
 	},
 	//remote control

Alessandro, thanks very much for your effort!

Cheers,

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net

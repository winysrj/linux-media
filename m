Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35539 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3ABIaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 03:30:12 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so6651423eek.19
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 00:30:10 -0800 (PST)
Message-ID: <50E3F00F.6040903@gmail.com>
Date: Wed, 02 Jan 2013 09:30:07 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: palatis@gmail.com
Subject: [PATCH/RFC] crystalhd-video (vaapi-backend): struct VADriverVTable
 *vtable; is heap, updated to API 0.32, configure GLX support misdetection
Content-Type: multipart/mixed;
 boundary="------------080904040806090605000004"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080904040806090605000004
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, I've found at http://gitorious.org/crystalhd-video "palatis" has started an vaapi backend for crystalhd and updated it to API rev. 0.32

but RFC #1, Applicable Linux Media API for Broadcom Crystal HD decoders:

I don't know yet if vaapi or vdpau is the right approach for a acceptable API for Broadcom crystal hd decoders, since it's a decoder (codec) not just an accelerator on such GPUs
and as I understand the little documentation so far, both APIs are X-Server rendering dependant but we've got many decoding only and framebuffer, transcoding and embedded
systems use cases around to which neither the vdpau nor the vaapi concepts would apply then and both API were useless for transcoders then?
Altough I don't know either yet if the Broadcom firmwares do allow faster than realtime movie framerate at all what transcoders usually need?
According to the ISO-OSI model, I would not mix or force decoding and/to X- Output in one API model and leave such (hw-) codecs in ffmpeg etc.

Fixes:

1. glx ext not detected by configure
crystalhd-video configuration summary:

VA-API version ................... : 0.32.0
VA-API drivers path .............. : /usr/lib/i386-linux-gnu/dri
CRYSTALHD version ................ : "3"
GLX support ...................... : no <------- ?

# dpkg -L libva-dev |grep -i glx
/usr/lib/i386-linux-gnu/pkgconfig/libva-glx.pc
/usr/include/va/va_glx.h
/usr/include/va/va_backend_glx.h
/usr/lib/i386-linux-gnu/libva-glx.so

Debug? ........................... : yes
Tracer? .......................... : yes

2. struct VADriverVTable *vtable; is heap, not stack allocateable in API 0.32, patch attached.

libtool: compile:  gcc -DHAVE_CONFIG_H -I. -std=c99 -g -O2 -D__LINUX_USER__ -MT crystalhd_drv_video.lo -MD -MP -MF .deps/crystalhd_drv_video.Tpo -c crystalhd_drv_video.c  -fPIC -DPIC -o .libs/crystalhd_drv_video.o
crystalhd_drv_video.c: In function '__vaDriverInit_0_31':
crystalhd_drv_video.c:1851:13: error: request for member 'vaTerminate' in something not a structure or union
...
crystalhd_drv_video.c:1894:13: error: request for member 'vaBufferInfo' in something not a structure or union
make[2]: *** [crystalhd_drv_video.lo] Fehler 1

3. test results:

init: vainfo:

Running DIL (3.22.0) Version
DtsDeviceOpen: Opening HW in mode 0
Clock set to 180
vainfo: VA-API version: 0.32 (libva 1.0.15)
vainfo: Driver version: Broadcom Crystal HD Video Decoder 3.10.0.0
vainfo: Supported profile and entrypoints
        VAProfileMPEG2Simple            :	VAEntrypointVLD
        VAProfileMPEG2Simple            :	VAEntrypointMoComp
        VAProfileMPEG2Main              :	VAEntrypointVLD
        VAProfileMPEG2Main              :	VAEntrypointMoComp
        VAProfileH264Baseline           :	VAEntrypointVLD
        VAProfileH264Main               :	VAEntrypointVLD
        VAProfileH264High               :	VAEntrypointVLD
DtsAllocIoctlData Error

Manually linked to my GPU chipset name
ln -s /usr/lib/i386-linux-gnu/dri/crystalhd_drv_video.so /usr/lib/i386-linux-gnu/dri/i915_drv_video.so
but nothing is accessing it it seems.

y
tom

-Att: patch against http://gitorious.org/crystalhd-video git master,HEAD at the timestamp of file.




--------------080904040806090605000004
Content-Type: text/x-diff;
 name="crystalhd-vaapi-forDebWheezy.schorpp.01.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="crystalhd-vaapi-forDebWheezy.schorpp.01.patch"

diff --git a/extra/crystalhd_wrapper/crystalhd_common.c b/extra/crystalhd_wrapper/crystalhd_common.c
index c26d5a5..e0c7eb0 100644
--- a/extra/crystalhd_wrapper/crystalhd_common.c
+++ b/extra/crystalhd_wrapper/crystalhd_common.c
@@ -48,7 +48,7 @@ const char *string_of_BC_STATUS(BC_STATUS status)
 		STATUS(CERT_VERIFY_ERROR);
 		STATUS(DEC_EXIST_OPEN);
 		STATUS(PENDING);
-		STATUS(CLK_NOCHG);
+//		STATUS(CLK_NOCHG);
 		STATUS(ERROR);
 #undef STATUS
 	}
diff --git a/src/crystalhd_drv_video.c b/src/crystalhd_drv_video.c
index 5fbae33..8f99f6a 100644
--- a/src/crystalhd_drv_video.c
+++ b/src/crystalhd_drv_video.c
@@ -1828,7 +1828,7 @@ crystalhd_Terminate(
 }
 
 VAStatus
-__vaDriverInit_0_31(
+__vaDriverInit_0_32(
 		VADriverContextP ctx
 	)
 {
@@ -1848,50 +1848,50 @@ __vaDriverInit_0_31(
 	ctx->max_display_attributes = CRYSTALHD_MAX_DISPLAY_ATTRIBUTES;
 	ctx->str_vendor = CRYSTALHD_STR_VENDOR;
 
-	ctx->vtable.vaTerminate = crystalhd_Terminate;
-	ctx->vtable.vaQueryConfigEntrypoints = crystalhd_QueryConfigEntrypoints;
-	ctx->vtable.vaQueryConfigProfiles = crystalhd_QueryConfigProfiles;
-	ctx->vtable.vaQueryConfigEntrypoints = crystalhd_QueryConfigEntrypoints;
-	ctx->vtable.vaQueryConfigAttributes = crystalhd_QueryConfigAttributes;
-	ctx->vtable.vaCreateConfig = crystalhd_CreateConfig;
-	ctx->vtable.vaDestroyConfig = crystalhd_DestroyConfig;
-	ctx->vtable.vaGetConfigAttributes = crystalhd_GetConfigAttributes;
-	ctx->vtable.vaCreateSurfaces = crystalhd_CreateSurfaces;
-	ctx->vtable.vaDestroySurfaces = crystalhd_DestroySurfaces;
-	ctx->vtable.vaCreateContext = crystalhd_CreateContext;
-	ctx->vtable.vaDestroyContext = crystalhd_DestroyContext;
-	ctx->vtable.vaCreateBuffer = crystalhd_CreateBuffer;
-	ctx->vtable.vaBufferSetNumElements = crystalhd_BufferSetNumElements;
-	ctx->vtable.vaMapBuffer = crystalhd_MapBuffer;
-	ctx->vtable.vaUnmapBuffer = crystalhd_UnmapBuffer;
-	ctx->vtable.vaDestroyBuffer = crystalhd_DestroyBuffer;
-	ctx->vtable.vaBeginPicture = crystalhd_BeginPicture;
-	ctx->vtable.vaRenderPicture = crystalhd_RenderPicture;
-	ctx->vtable.vaEndPicture = crystalhd_EndPicture;
-	ctx->vtable.vaSyncSurface = crystalhd_SyncSurface;
-	ctx->vtable.vaQuerySurfaceStatus = crystalhd_QuerySurfaceStatus;
-	ctx->vtable.vaPutSurface = crystalhd_PutSurface;
-	ctx->vtable.vaQueryImageFormats = crystalhd_QueryImageFormats;
-	ctx->vtable.vaCreateImage = crystalhd_CreateImage;
-	ctx->vtable.vaDeriveImage = crystalhd_DeriveImage;
-	ctx->vtable.vaDestroyImage = crystalhd_DestroyImage;
-	ctx->vtable.vaSetImagePalette = crystalhd_SetImagePalette;
-	ctx->vtable.vaGetImage = crystalhd_GetImage;
-	ctx->vtable.vaPutImage = crystalhd_PutImage;
-	ctx->vtable.vaQuerySubpictureFormats = crystalhd_QuerySubpictureFormats;
-	ctx->vtable.vaCreateSubpicture = crystalhd_CreateSubpicture;
-	ctx->vtable.vaDestroySubpicture = crystalhd_DestroySubpicture;
-	ctx->vtable.vaSetSubpictureImage = crystalhd_SetSubpictureImage;
-	ctx->vtable.vaSetSubpictureChromakey = crystalhd_SetSubpictureChromakey;
-	ctx->vtable.vaSetSubpictureGlobalAlpha = crystalhd_SetSubpictureGlobalAlpha;
-	ctx->vtable.vaAssociateSubpicture = crystalhd_AssociateSubpicture;
-	ctx->vtable.vaDeassociateSubpicture = crystalhd_DeassociateSubpicture;
-	ctx->vtable.vaQueryDisplayAttributes = crystalhd_QueryDisplayAttributes;
-	ctx->vtable.vaGetDisplayAttributes = crystalhd_GetDisplayAttributes;
-	ctx->vtable.vaSetDisplayAttributes = crystalhd_SetDisplayAttributes;
-	ctx->vtable.vaLockSurface = crystalhd_LockSurface;
-	ctx->vtable.vaUnlockSurface = crystalhd_UnlockSurface;
-	ctx->vtable.vaBufferInfo = crystalhd_BufferInfo;
+	ctx->vtable->vaTerminate = crystalhd_Terminate;
+	ctx->vtable->vaQueryConfigEntrypoints = crystalhd_QueryConfigEntrypoints;
+	ctx->vtable->vaQueryConfigProfiles = crystalhd_QueryConfigProfiles;
+	ctx->vtable->vaQueryConfigEntrypoints = crystalhd_QueryConfigEntrypoints;
+	ctx->vtable->vaQueryConfigAttributes = crystalhd_QueryConfigAttributes;
+	ctx->vtable->vaCreateConfig = crystalhd_CreateConfig;
+	ctx->vtable->vaDestroyConfig = crystalhd_DestroyConfig;
+	ctx->vtable->vaGetConfigAttributes = crystalhd_GetConfigAttributes;
+	ctx->vtable->vaCreateSurfaces = crystalhd_CreateSurfaces;
+	ctx->vtable->vaDestroySurfaces = crystalhd_DestroySurfaces;
+	ctx->vtable->vaCreateContext = crystalhd_CreateContext;
+	ctx->vtable->vaDestroyContext = crystalhd_DestroyContext;
+	ctx->vtable->vaCreateBuffer = crystalhd_CreateBuffer;
+	ctx->vtable->vaBufferSetNumElements = crystalhd_BufferSetNumElements;
+	ctx->vtable->vaMapBuffer = crystalhd_MapBuffer;
+	ctx->vtable->vaUnmapBuffer = crystalhd_UnmapBuffer;
+	ctx->vtable->vaDestroyBuffer = crystalhd_DestroyBuffer;
+	ctx->vtable->vaBeginPicture = crystalhd_BeginPicture;
+	ctx->vtable->vaRenderPicture = crystalhd_RenderPicture;
+	ctx->vtable->vaEndPicture = crystalhd_EndPicture;
+	ctx->vtable->vaSyncSurface = crystalhd_SyncSurface;
+	ctx->vtable->vaQuerySurfaceStatus = crystalhd_QuerySurfaceStatus;
+	ctx->vtable->vaPutSurface = crystalhd_PutSurface;
+	ctx->vtable->vaQueryImageFormats = crystalhd_QueryImageFormats;
+	ctx->vtable->vaCreateImage = crystalhd_CreateImage;
+	ctx->vtable->vaDeriveImage = crystalhd_DeriveImage;
+	ctx->vtable->vaDestroyImage = crystalhd_DestroyImage;
+	ctx->vtable->vaSetImagePalette = crystalhd_SetImagePalette;
+	ctx->vtable->vaGetImage = crystalhd_GetImage;
+	ctx->vtable->vaPutImage = crystalhd_PutImage;
+	ctx->vtable->vaQuerySubpictureFormats = crystalhd_QuerySubpictureFormats;
+	ctx->vtable->vaCreateSubpicture = crystalhd_CreateSubpicture;
+	ctx->vtable->vaDestroySubpicture = crystalhd_DestroySubpicture;
+	ctx->vtable->vaSetSubpictureImage = crystalhd_SetSubpictureImage;
+	ctx->vtable->vaSetSubpictureChromakey = crystalhd_SetSubpictureChromakey;
+	ctx->vtable->vaSetSubpictureGlobalAlpha = crystalhd_SetSubpictureGlobalAlpha;
+	ctx->vtable->vaAssociateSubpicture = crystalhd_AssociateSubpicture;
+	ctx->vtable->vaDeassociateSubpicture = crystalhd_DeassociateSubpicture;
+	ctx->vtable->vaQueryDisplayAttributes = crystalhd_QueryDisplayAttributes;
+	ctx->vtable->vaGetDisplayAttributes = crystalhd_GetDisplayAttributes;
+	ctx->vtable->vaSetDisplayAttributes = crystalhd_SetDisplayAttributes;
+	ctx->vtable->vaLockSurface = crystalhd_LockSurface;
+	ctx->vtable->vaUnlockSurface = crystalhd_UnlockSurface;
+	ctx->vtable->vaBufferInfo = crystalhd_BufferInfo;
 
 	struct crystalhd_driver_data *driver_data = (struct crystalhd_driver_data *) malloc( sizeof(*driver_data) );
 	if ( NULL == driver_data )


--------------080904040806090605000004--

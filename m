Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4F1HuC4022090
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 21:17:56 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.237])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4F1Hkwt007767
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 21:17:46 -0400
Received: by rv-out-0506.google.com with SMTP id f6so192999rvb.51
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 18:17:42 -0700 (PDT)
Message-ID: <d9def9db0805141817n4182deedp780791b0a51fb7be@mail.gmail.com>
Date: Thu, 15 May 2008 03:17:42 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Greg KH" <greg@kroah.com>
In-Reply-To: <20080514205927.GA13134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080514205927.GA13134@kroah.com>
Cc: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
	linux-usb@vger.kernel.org, video4linux-list@redhat.com,
	mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] USB: add Sensoray 2255 v4l driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Dean, Greg,

On 5/14/08, Greg KH <greg@kroah.com> wrote:
> From: Dean Anderson <dean@sensoray.com>
>
> +static int norm_maxw(struct video_device *vdev)
> +{
> +	return (vdev->current_norm != V4L2_STD_PAL_B) ?
> +	    LINE_SZ_4CIFS_NTSC : LINE_SZ_4CIFS_PAL;
> +}
> +
> +static int norm_maxh(struct video_device *vdev)
> +{
> +	return (vdev->current_norm != V4L2_STD_PAL_B) ?
> +	    (NUM_LINES_1CIFS_NTSC * 2) : (NUM_LINES_1CIFS_PAL * 2);
> +}
> +
> +static int norm_minw(struct video_device *vdev)
> +{
> +	return (vdev->current_norm != V4L2_STD_PAL_B) ?
> +	    LINE_SZ_1CIFS_NTSC : LINE_SZ_1CIFS_PAL;
> +}
> +
> +static int norm_minh(struct video_device *vdev)
> +{
> +	return (vdev->current_norm != V4L2_STD_PAL_B) ?
> +	    (NUM_LINES_1CIFS_NTSC) : (NUM_LINES_1CIFS_PAL);
> +}
> +
> +/*
> + * convert from YUV(YCrCb) to RGB
> + * 65536 R = 76533(Y-16) + 104936 * (Cr-128)
> + * 65536 G = 76533(Y-16) - 53451(Cr-128) - 25703(Cb -128)
> + * 65536 B = 76533(Y-16) + 132677(Cb-128)
> + */
> +static void YCrCb2RGB(int Y, int Cr, int Cb, unsigned char *pR,
> +		      unsigned char *pG, unsigned char *pB)
> +{
> +	int R, G, B;
> +
> +	Y = Y - 16;
> +	Cr = Cr - 128;
> +	Cb = Cb - 128;
> +
> +	R = (76533 * Y + 104936 * Cr) >> 16;
> +	G = ((76533 * Y) - (53451 * Cr) - (25703 * Cb)) >> 16;
> +	B = ((76533 * Y) + (132677 * Cb)) >> 16;
> +	/* even with proper conversion, some values still need clipping. */
> +	if (R > 255)
> +		R = 255;
> +	if (G > 255)
> +		G = 255;
> +	if (B > 255)
> +		B = 255;
> +	if (R < 0)
> +		R = 0;
> +	if (G < 0)
> +		G = 0;
> +	if (B < 0)
> +		B = 0;
> +	*pR = R;
> +	*pG = G;
> +	*pB = B;
> +	return;
> +}
> +
> +/* converts 2255 planar format to yuyv */
> +static void planar422p_to_yuy2(const unsigned char *in, unsigned char *out,
> +			       int width, int height)
> +{
> +	unsigned char *pY;
> +	unsigned char *pCb;
> +	unsigned char *pCr;
> +	unsigned long size = height * width;
> +	unsigned int i;
> +	pY = (unsigned char *)in;
> +	pCr = (unsigned char *)in + height * width;
> +	pCb = (unsigned char *)in + height * width + (height * width / 2);
> +	for (i = 0; i < size * 2; i += 4) {
> +		out[i] = *pY++;
> +		out[i + 1] = *pCr++;
> +		out[i + 2] = *pY++;
> +		out[i + 3] = *pCb++;
> +	}
> +	return;
> +}
> +
> +/*
> + * basic 422 planar to RGB24 or BGR24 software conversion.
> + * This is best done with MMX. Update to kernel function
> + * when image conversion functions added to kernel.
> + */
> +static void planar422p_to_rgb24(const unsigned char *in,
> +				unsigned char *out, int width,
> +				int height, int rev_order)
> +{
> +	unsigned char *pY;
> +	unsigned char *pYEND;
> +	unsigned char *pCb;
> +	unsigned char *pCr;
> +	unsigned char Cr, Cb, Y, r, g, b;
> +	unsigned long k = 0;
> +	pY = (unsigned char *)in;
> +	pCb = (unsigned char *)in + (height * width);
> +	pCr = (unsigned char *)in + (height * width) + (height * width / 2);
> +	pYEND = pCb;
> +	while (pY < pYEND) {
> +		Y = *pY++;
> +		Cr = *pCr;
> +		Cb = *pCb;
> +		YCrCb2RGB(Y, Cr, Cb, &r, &g, &b);
> +		out[k++] = !rev_order ? b : r;
> +		out[k++] = g;
> +		out[k++] = !rev_order ? r : b;
> +		if (pY >= pYEND)
> +			break;
> +		Y = *pY++;
> +		Cr = *pCr++;
> +		Cb = *pCb++;
> +		YCrCb2RGB(Y, Cr, Cb, &r, &g, &b);
> +		out[k++] = !rev_order ? b : r;
> +		out[k++] = g;
> +		out[k++] = !rev_order ? r : b;
> +	}
> +	return;
> +}
> +
> +static void planar422p_to_rgb32(const unsigned char *in, unsigned char
> *out,
> +				int width, int height, int rev_order)
> +{
> +	unsigned char *pY;
> +	unsigned char *pYEND;
> +	unsigned char *pCb;
> +	unsigned char *pCr;
> +	unsigned char Cr, Cb, Y, r, g, b;
> +	unsigned long k = 0;
> +	pY = (unsigned char *)in;
> +	pCb = (unsigned char *)in + (height * width);
> +	pCr = (unsigned char *)in + (height * width) + (height * width / 2);
> +	pYEND = pCb;
> +	while (pY < pYEND) {
> +		Y = *pY++;
> +		Cr = *pCr;
> +		Cb = *pCb;
> +		YCrCb2RGB(Y, Cr, Cb, &r, &g, &b);
> +		out[k++] = rev_order ? b : r;
> +		out[k++] = g;
> +		out[k++] = rev_order ? r : b;
> +		out[k++] = 0;
> +		if (pY >= pYEND)
> +			break;
> +		Y = *pY++;
> +		Cr = *pCr++;
> +		Cb = *pCb++;
> +		YCrCb2RGB(Y, Cr, Cb, &r, &g, &b);
> +		out[k++] = rev_order ? b : r;
> +		out[k++] = g;
> +		out[k++] = rev_order ? r : b;
> +		out[k++] = 0;
> +	}
> +
> +	return;
> +}
> +
> +static void planar422p_to_rgb565(unsigned char const *in, unsigned char
> *out,
> +				 int width, int height, int rev_order)
> +{
> +	unsigned char *pY;
> +	unsigned char *pYEND;
> +	unsigned char *pCb;
> +	unsigned char *pCr;
> +	unsigned char Cr, Cb, Y, r, g, b;
> +	unsigned long k = 0;
> +	unsigned short rgbbytes;
> +	pY = (unsigned char *)in;
> +	pCb = (unsigned char *)in + (height * width);
> +	pCr = (unsigned char *)in + (height * width) + (height * width / 2);
> +	pYEND = pCb;
> +	while (pY < pYEND) {
> +		Y = *pY++;
> +		Cr = *pCr;
> +		Cb = *pCb;
> +		YCrCb2RGB(Y, Cr, Cb, &r, &g, &b);
> +		r = r >> 3;
> +		g = g >> 2;
> +		b = b >> 3;
> +		if (rev_order)
> +			rgbbytes = b + (g << 5) + (r << (5 + 6));
> +		else
> +			rgbbytes = r + (g << 5) + (b << (5 + 6));
> +		out[k++] = rgbbytes & 0xff;
> +		out[k++] = (rgbbytes >> 8) & 0xff;
> +		Y = *pY++;
> +		Cr = *pCr++;
> +		Cb = *pCb++;
> +		YCrCb2RGB(Y, Cr, Cb, &r, &g, &b);
> +		r = r >> 3;
> +		g = g >> 2;
> +		b = b >> 3;
> +		if (rev_order)
> +			rgbbytes = b + (g << 5) + (r << (5 + 6));
> +		else
> +			rgbbytes = r + (g << 5) + (b << (5 + 6));
> +		out[k++] = rgbbytes & 0xff;
> +		out[k++] = (rgbbytes >> 8) & 0xff;
> +	}
> +	return;
> +}
> +


Why do you do those conversions in kernelspace?
ffmpeg/libswscale has optimized code for colourspace conversions.
I know a few drivers do that in kernelspace but it's way more flexible
in userspace and depending on the optimization requires less CPU
power.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

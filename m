Return-path: <linux-media-owner@vger.kernel.org>
Received: from alln-iport-7.cisco.com ([173.37.142.94]:38341 "EHLO
	alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbbFHLeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 07:34:10 -0400
From: "Prashant Laddha (prladdha)" <prladdha@cisco.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH] v4l2-dv-timings: add support for reduced blanking v2
Date: Mon, 8 Jun 2015 11:24:41 +0000
Message-ID: <D19B7906.4BD32%prladdha@cisco.com>
In-Reply-To: <557571F0.90109@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4DF5920EBBEE24E98548228AB377BF3@emea.cisco.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the review Hans. I will address your comments and post revised
patches for this.

Regards,
Prashant

On 08/06/15 4:14 pm, "Hans Verkuil" <hverkuil@xs4all.nl> wrote:

>On 06/05/2015 10:52 AM, Prashant Laddha wrote:
>> Added support for reduced blanking version 2 (RB v2) in cvt timings.
>> Standard specifies a fixed vsync pulse of 8 lines to indicate RB v2
>> timings. Vertical back porch is fixed at 6 lines and vertical front
>> porch is remainder of vertical blanking time.
>> 
>> For Rb v2, horizontal blanking is fixed at 80 pixels. Horizontal sync
>> is fixed at 32. All horizontal timing counts (active pixels, front,
>> back porches) can be specified upto a precision of 1.
>> 
>> To Do: Pass aspect ratio information to v4l2_detect_cvt()
>> RB v2 allows for non standard aspect ratios. In RB v2 vsync does not
>> indicate aspect ratio. In the absence of aspect ratio information,
>> v4l2_detect_cvt() cannot calculate image width from image height.
>
>Reading the CVT spec I see that RB v2 assumes that the pixel aspect ratio
>is always square (section 3.4.3, item 7 says that the aspect ratio is
>to be derived from the active video resolution, which is only possible
>if the pixel aspect ratio is square.
>
>So I would suggest adding a 'frame_width' argument to v4l2_detect_cvt:
>this
>will be used in the v2 case. If RB v2 is detected and frame_width is 0,
>then
>v4l2_detect_cvt will return false.
>
>Since RB v2 is something we'll only see with digital video interfaces
>where
>we always know the horizontal active video, this shouldn't be a problem.
>
>Some code comments below:
>
>> 
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Signed-off-by: Prashant Laddha <prladdha@cisco.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-dv-timings.c | 72
>>+++++++++++++++++++++++--------
>>  1 file changed, 54 insertions(+), 18 deletions(-)
>> 
>> diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c
>>b/drivers/media/v4l2-core/v4l2-dv-timings.c
>> index 0d849fc..4efc6f6 100644
>> --- a/drivers/media/v4l2-core/v4l2-dv-timings.c
>> +++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
>> @@ -309,6 +309,7 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
>>   */
>>  
>>  #define CVT_PXL_CLK_GRAN	250000	/* pixel clock granularity */
>> +#define CVT_PXL_CLK_GRAN_RB_V2 1000	/* granularity for reduced
>>blanking v2*/
>>  
>>  /* Normal blanking */
>>  #define CVT_MIN_V_BPORCH	7	/* lines */
>> @@ -328,10 +329,14 @@ EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
>>  /* Reduced Blanking */
>>  #define CVT_RB_MIN_V_BPORCH    7       /* lines  */
>>  #define CVT_RB_V_FPORCH        3       /* lines  */
>> -#define CVT_RB_MIN_V_BLANK   460     /* us     */
>> +#define CVT_RB_MIN_V_BLANK   460       /* us     */
>>  #define CVT_RB_H_SYNC         32       /* pixels */
>> -#define CVT_RB_H_BPORCH       80       /* pixels */
>>  #define CVT_RB_H_BLANK       160       /* pixels */
>> +/* Reduce blanking Version 2 */
>> +#define CVT_RB_V2_H_BLANK     80       /* pixels */
>> +#define CVT_RB_MIN_V_FPORCH    3       /* lines  */
>> +#define CVT_RB_V2_MIN_V_FPORCH 1       /* lines  */
>> +#define CVT_RB_V_BPORCH        6       /* lines  */
>>  
>>  /** v4l2_detect_cvt - detect if the given timings follow the CVT
>>standard
>>   * @frame_height - the total height of the frame (including blanking)
>>in lines.
>> @@ -356,9 +361,10 @@ bool v4l2_detect_cvt(unsigned frame_height,
>>unsigned hfreq, unsigned vsync,
>>  	int  v_fp, v_bp, h_fp, h_bp, hsync;
>>  	int  frame_width, image_height, image_width;
>>  	bool reduced_blanking;
>> +	bool rb_v2 = false;
>>  	unsigned pix_clk;
>>  
>> -	if (vsync < 4 || vsync > 7)
>> +	if (vsync < 4 || vsync > 8)
>>  		return false;
>>  
>>  	if (polarities == V4L2_DV_VSYNC_POS_POL)
>> @@ -368,17 +374,32 @@ bool v4l2_detect_cvt(unsigned frame_height,
>>unsigned hfreq, unsigned vsync,
>>  	else
>>  		return false;
>>  
>> +	if (reduced_blanking && vsync == 8)
>> +		rb_v2 = true;
>> +
>> +	if (!rb_v2 && vsync > 7)
>> +		return false;
>> +
>>  	if (hfreq == 0)
>>  		return false;
>>  
>>  	/* Vertical */
>>  	if (reduced_blanking) {
>> -		v_fp = CVT_RB_V_FPORCH;
>> -		v_bp = (CVT_RB_MIN_V_BLANK * hfreq) / 1000000 + 1;
>> -		v_bp -= vsync + v_fp;
>> -
>> -		if (v_bp < CVT_RB_MIN_V_BPORCH)
>> -			v_bp = CVT_RB_MIN_V_BPORCH;
>> +		if (rb_v2) {
>> +			v_bp = CVT_RB_V_BPORCH;
>> +			v_fp = (CVT_RB_MIN_V_BLANK * hfreq) / 1000000 + 1;
>> +			v_fp -= vsync + v_bp;
>> +
>> +			if (v_fp < CVT_RB_V2_MIN_V_FPORCH)
>> +				v_fp = CVT_RB_V2_MIN_V_FPORCH;
>> +		} else {
>> +			v_fp = CVT_RB_V_FPORCH;
>> +			v_bp = (CVT_RB_MIN_V_BLANK * hfreq) / 1000000 + 1;
>> +			v_bp -= vsync + v_fp;
>> +
>> +			if (v_bp < CVT_RB_MIN_V_BPORCH)
>> +				v_bp = CVT_RB_MIN_V_BPORCH;
>> +		}
>>  	} else {
>>  		v_fp = CVT_MIN_V_PORCH_RND;
>>  		v_bp = (CVT_MIN_VSYNC_BP * hfreq) / 1000000 + 1 - vsync;
>> @@ -415,22 +436,40 @@ bool v4l2_detect_cvt(unsigned frame_height,
>>unsigned hfreq, unsigned vsync,
>>  		else
>>  			return false;
>>  		break;
>> +	case 8:
>> +	/* To Do:
>> +	 * For Reduced Blanking v2, vsync does not indicate aspect ratio and
>> +	 * hence can not be used to derive image width. In such a case, either
>> +	 * aspect ratio information or image width should be supplied to
>> +	 * v4l2_detect_cvt(). This would need API change. As of now assuming
>> +	 * 16:9 as default aspect ratio.
>> +	 * */
>> +		image_width = (image_height * 16) / 9;
>> +		break;
>>  	default:
>>  		return false;
>>  	}
>>  
>> -	image_width = image_width & ~7;
>> +	if (!rb_v2)
>> +		image_width = image_width & ~7;
>>  
>>  	/* Horizontal */
>>  	if (reduced_blanking) {
>> -		pix_clk = (image_width + CVT_RB_H_BLANK) * hfreq;
>> -		pix_clk = (pix_clk / CVT_PXL_CLK_GRAN) * CVT_PXL_CLK_GRAN;
>> +		int h_blank;
>>  
>> -		h_bp = CVT_RB_H_BPORCH;
>> +		if (rb_v2)
>> +			h_blank = CVT_RB_V2_H_BLANK;
>> +		else
>> +			h_blank = CVT_RB_H_BLANK;
>
>I prefer: h_blank = rb_v2 ? CVT_RB_V2_H_BLANK : CVT_RB_H_BLANK
>
>> +
>> +		pix_clk = (image_width + h_blank) * hfreq;
>> +		pix_clk = (pix_clk / CVT_PXL_CLK_GRAN_RB_V2) *
>>CVT_PXL_CLK_GRAN_RB_V2;
>
>Shouldn't the granularity be dependent on rb_v2?
>
>> +
>> +		h_bp  = h_blank / 2;
>>  		hsync = CVT_RB_H_SYNC;
>> -		h_fp = CVT_RB_H_BLANK - h_bp - hsync;
>> +		h_fp  = h_blank - h_bp - hsync;
>>  
>> -		frame_width = image_width + CVT_RB_H_BLANK;
>> +		frame_width = image_width + h_blank;
>>  	} else {
>>  		unsigned ideal_duty_cycle_per_myriad =
>>  			100 * CVT_C_PRIME - (CVT_M_PRIME * 100000) / hfreq;
>> @@ -438,11 +477,9 @@ bool v4l2_detect_cvt(unsigned frame_height,
>>unsigned hfreq, unsigned vsync,
>>  
>>  		if (ideal_duty_cycle_per_myriad < 2000)
>>  			ideal_duty_cycle_per_myriad = 2000;
>> -
>>  		h_blank = image_width * ideal_duty_cycle_per_myriad /
>>  					(10000 - ideal_duty_cycle_per_myriad);
>>  		h_blank = (h_blank / (2 * CVT_CELL_GRAN)) * 2 * CVT_CELL_GRAN;
>> -
>
>Why the spurious whitespace changes?
>
>>  		pix_clk = (image_width + h_blank) * hfreq;
>>  		pix_clk = (pix_clk / CVT_PXL_CLK_GRAN) * CVT_PXL_CLK_GRAN;
>>  
>> @@ -483,7 +520,6 @@ bool v4l2_detect_cvt(unsigned frame_height,
>>unsigned hfreq, unsigned vsync,
>>  
>>  	if (reduced_blanking)
>>  		fmt->bt.flags |= V4L2_DV_FL_REDUCED_BLANKING;
>> -
>
>Ditto.
>
>>  	return true;
>>  }
>>  EXPORT_SYMBOL_GPL(v4l2_detect_cvt);
>> 
>
>Regards,
>
>	Hans


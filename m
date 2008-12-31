Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBVLOqde018601
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 16:24:52 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBVLOUtS031679
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 16:24:31 -0500
Received: by wf-out-1314.google.com with SMTP id 25so5812849wfc.6
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 13:24:29 -0800 (PST)
Message-ID: <c785bba30812311324x17088a2hc3e45f3c00f3f402@mail.gmail.com>
Date: Wed, 31 Dec 2008 14:24:29 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <c785bba30812311258v1349ecb2pa95cd4ffbcf523c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
	<c785bba30812311134v86c1552o6fb7e76191c50182@mail.gmail.com>
	<412bdbff0812311137o74aa3aa0y49248109f968f7e8@mail.gmail.com>
	<c785bba30812311139tc76131fx61deb0a99f99ff1b@mail.gmail.com>
	<412bdbff0812311142k46fed3adtd152498a0e391715@mail.gmail.com>
	<c785bba30812311203t405b7a98j42f139e3c3b8134a@mail.gmail.com>
	<412bdbff0812311206h435e64f2qed62499b339c53d7@mail.gmail.com>
	<c785bba30812311209k16ef6f04jc3d8867a64d4cb93@mail.gmail.com>
	<c785bba30812311220pc0a5143i67101e896b62e870@mail.gmail.com>
	<c785bba30812311258v1349ecb2pa95cd4ffbcf523c1@mail.gmail.com>
Subject: Re: em28xx issues
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

Well I've got it to sort of work. If I use the skype and look at the
video preview then it seems to work. However if I close skype and
reopen it, it no longer works. I have to un-plug and plug the device
to get it to work again. And no other program works yet.

Here is the status of the other cam programs:
camstream                 -> seg fault
gstreamer-properties  -> seg fault
cheese                      -> uses test input
fswebcam                  -> black screen with green stripe

thanks,
Paul

On Wed, Dec 31, 2008 at 1:58 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
> When I start camstream with the new driver this is what I get. This is
> a slightly different setup that I first described. It a x86_64 with
> Fedora 9.
>
> CCamWindow::CCamWindow()
> CWebCamViewer::CWebCamViewer(0xfbf8c0, 0x0)
> CVideoDevice::Init()
> Using mmap(), VMBuf.size = 6651904
> CVideoDevice::Init(): mmap() failed (22). Falling back to non-mmap()ed mode.
> Allocating own buffer.
> Trying to find video options for PointNix Intra-Oral Camera:/dev/video0
> Creating new video options
> <!DOCTYPE Configuration>
> <config>
>  <defaults/>
>  <videodevices>
>  <videoconfiguration name="PointNix Intra-Oral Camera" >
>   <basename>snapshot</basename>
>   <textfont>system</textfont>
>   <textcolor>#ffff00</textcolor>
>   <timeinimage>false</timeinimage>
>   <fileformat>PNG</fileformat>
>   <savetodisk>true</savetodisk>
>   <ftptoserver>false</ftptoserver>
>   <saveoption>1</saveoption>
>   <maxsequence>1000</maxsequence>
>   <sequence>0</sequence>
>   <ftpserver></ftpserver>
>   <ftppath></ftppath>
>   <ftpuser></ftpuser>
>   <ftppass></ftppass>
>   <ftppassive>false</ftppassive>
>   <ftpunique>true</ftpunique>
>  </videoconfiguration>
>  </videodevices>
> </config>
>
> CSnapshotSettingsDlg::CSnapshotSettingsDlg(...)
> QFont::setRawName(): Invalid XLFD: "system"
> CVideoSettingsDlg::SizeChanged(720x576)
> CVideoSettingsDlg::FramerateChanged(10)
> CCamPanel::SetSize(720x576)
> CCamPanel::SetImageSize(720x576)
> CCamPanel::SetVisibleSize(720x576)
> CCamPanel::SetSize(720x576)
> CCamPanel::SetImageSize(720x576)
> CCamPanel::SetVisibleSize(720x576)
> RecalcTotalViewSize: resize viewport(720x576)
> EnableRGB: +
> CVideoDevice::SetPalette picked palette 8 [yuyv]
> CVideoDevice::CreateImagesRGB()
>  allocating space for RGB
> CVideoDevice::StartCapture() go!
> Segmentation fault
>
> On Wed, Dec 31, 2008 at 1:20 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
>> OK, after a restart the driver loads properly. It's still not working,
>> but I have to look at a couple of things.
>>
>> thanks,
>> Paul
>>
>> On Wed, Dec 31, 2008 at 1:09 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
>>> The v4l-dvb directory is clean aside from the KERNEL_VERSION(2, 6, 27) change.
>>>
>>> thanks,
>>> Paul
>>>
>>> On Wed, Dec 31, 2008 at 1:06 PM, Devin Heitmueller
>>> <devin.heitmueller@gmail.com> wrote:
>>>> On Wed, Dec 31, 2008 at 3:03 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
>>>>> OK, I can compile now, but when I go to modprobe em28xx I get this error.
>>>>>
>>>>> em28xx: Unknown symbol ir_codes_ati_tv_wonder_hd_600
>>>>>
>>>>> thanks,
>>>>> Paul
>>>>
>>>> Do you have some mix of files from the em28xx-new and the v4l-dvb
>>>> codebase?  Or did you jam a reference in the include path to
>>>> em28xx-new's include directory?
>>>>
>>>> Devin
>>>>
>>>> --
>>>> Devin J. Heitmueller
>>>> http://www.devinheitmueller.com
>>>> AIM: devinheitmueller
>>>>
>>>
>>
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

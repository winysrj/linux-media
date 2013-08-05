Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2365 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3HEJbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 05:31:18 -0400
Message-ID: <51FF70DF.1010605@xs4all.nl>
Date: Mon, 05 Aug 2013 11:31:11 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?QsOlcmQgRWlyaWsgV2ludGhlcg==?= <bwinther@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 7/7] qv4l2: add aspect ratio support
References: <1375693017-6079-1-git-send-email-bwinther@cisco.com> <1f361d3a48848e8b4918666cf80e4745efab8c0d.1375692973.git.bwinther@cisco.com>
In-Reply-To: <1f361d3a48848e8b4918666cf80e4745efab8c0d.1375692973.git.bwinther@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bård,

Some comments below...

On 08/05/2013 10:56 AM, Bård Eirik Winther wrote:
> Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
> ---
>  utils/qv4l2/capture-win.cpp | 24 ++++++++++++++++++++++--
>  utils/qv4l2/capture-win.h   |  8 +++++++-
>  utils/qv4l2/general-tab.cpp | 36 ++++++++++++++++++++++++++++++++++++
>  utils/qv4l2/general-tab.h   |  3 +++
>  utils/qv4l2/qv4l2.cpp       | 22 +++++++++++++++-------
>  utils/qv4l2/qv4l2.h         |  2 +-
>  6 files changed, 84 insertions(+), 11 deletions(-)
> 
> diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
> index 435c19b..415829a 100644
> --- a/utils/qv4l2/capture-win.cpp
> +++ b/utils/qv4l2/capture-win.cpp
> @@ -30,6 +30,7 @@
>  #define MIN_WIN_SIZE_HEIGHT 120
>  
>  bool CaptureWin::m_enableScaling = true;
> +double CaptureWin::m_pixelAspectRatio = 1.0;
>  
>  CaptureWin::CaptureWin() :
>  	m_curWidth(-1),
> @@ -73,6 +74,14 @@ void CaptureWin::resetSize()
>  	resize(w, h);
>  }
>  
> +int CaptureWin::actualFrameWidth(int width)
> +{
> +	if (m_enableScaling)
> +		return (int)((double)width * m_pixelAspectRatio);
> +	else

No need for the 'else' statement.

> +		return width;
> +}
> +
>  QSize CaptureWin::getMargins()
>  {
>  	int l, t, r, b;
> @@ -94,6 +103,14 @@ void CaptureWin::enableScaling(bool enable)
>  	delete event;
>  }
>  
> +void CaptureWin::setPixelAspectRatio(double ratio)
> +{
> +	m_pixelAspectRatio = ratio;
> +	QResizeEvent *event = new QResizeEvent(QSize(width(), height()), QSize(width(), height()));
> +	QCoreApplication::sendEvent(this, event);
> +	delete event;
> +}
> +
>  void CaptureWin::resize(int width, int height)
>  {
>  	// Dont resize window if the frame size is the same in
> @@ -105,7 +122,7 @@ void CaptureWin::resize(int width, int height)
>  	m_curHeight = height;
>  
>  	QSize margins = getMargins();
> -	width += margins.width();
> +	width = actualFrameWidth(width) + margins.width();
>  	height += margins.height();
>  
>  	QDesktopWidget *screen = QApplication::desktop();
> @@ -127,12 +144,15 @@ void CaptureWin::resize(int width, int height)
>  
>  QSize CaptureWin::scaleFrameSize(QSize window, QSize frame)
>  {
> -	int actualFrameWidth = frame.width();;
> +	int actualFrameWidth;
>  	int actualFrameHeight = frame.height();
>  
>  	if (!m_enableScaling) {
>  		window.setWidth(frame.width());
>  		window.setHeight(frame.height());
> +		actualFrameWidth = frame.width();
> +	} else {
> +		actualFrameWidth = CaptureWin::actualFrameWidth(frame.width());
>  	}
>  
>  	double newW, newH;
> diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
> index 1bfb1e1..eded9e0 100644
> --- a/utils/qv4l2/capture-win.h
> +++ b/utils/qv4l2/capture-win.h
> @@ -76,9 +76,10 @@ public:
>  	static bool isSupported() { return false; }
>  
>  	void enableScaling(bool enable);
> +	void setPixelAspectRatio(double ratio);
>  	static QSize scaleFrameSize(QSize window, QSize frame);
>  
> -public slots:
> +	public slots:
>  	void resetSize();
>  
>  protected:
> @@ -99,6 +100,11 @@ protected:
>  	 */
>  	static bool m_enableScaling;
>  
> +	/**
> +	 * @note Aspect ratio it taken care of by scaling, frame size is for square pixels only!
> +	 */
> +	static double m_pixelAspectRatio;
> +
>  signals:
>  	void close();
>  
> diff --git a/utils/qv4l2/general-tab.cpp b/utils/qv4l2/general-tab.cpp
> index 5996c03..53b7e36 100644
> --- a/utils/qv4l2/general-tab.cpp
> +++ b/utils/qv4l2/general-tab.cpp
> @@ -53,6 +53,7 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
>  	m_tvStandard(NULL),
>  	m_qryStandard(NULL),
>  	m_videoTimings(NULL),
> +	m_pixelAspectRatio(NULL),
>  	m_qryTimings(NULL),
>  	m_freq(NULL),
>  	m_vidCapFormats(NULL),
> @@ -210,6 +211,20 @@ GeneralTab::GeneralTab(const QString &device, v4l2 &fd, int n, QWidget *parent)
>  		connect(m_qryTimings, SIGNAL(clicked()), SLOT(qryTimingsClicked()));
>  	}
>  
> +	if (!isRadio() && !isVbi()) {
> +		m_pixelAspectRatio = new QComboBox(parent);
> +		m_pixelAspectRatio->addItem("Autodetect");
> +		m_pixelAspectRatio->addItem("Square");
> +		m_pixelAspectRatio->addItem("NTSC/PAL-M/PAL-60");
> +		m_pixelAspectRatio->addItem("NTSC/PAL-M/PAL-60, Anamorphic");
> +		m_pixelAspectRatio->addItem("PAL/SECAM");
> +		m_pixelAspectRatio->addItem("PAL/SECAM, Anamorphic");
> +
> +		addLabel("Pixel Aspect Ratio");
> +		addWidget(m_pixelAspectRatio);
> +		connect(m_pixelAspectRatio, SIGNAL(activated(int)), SIGNAL(pixelAspectRatioChanged()));
> +	}
> +
>  	if (m_tuner.capability) {
>  		QDoubleValidator *val;
>  		double factor = (m_tuner.capability & V4L2_TUNER_CAP_LOW) ? 16 : 16000;
> @@ -1105,6 +1120,27 @@ void GeneralTab::updateFrameSize()
>  	updateFrameInterval();
>  }
>  
> +double GeneralTab::getPixelAspectRatio()
> +{
> +	if (m_pixelAspectRatio->currentText().compare("Autodetect") == 0) {
> +		v4l2_cropcap ratio;
> +		ratio.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +		if (ioctl(VIDIOC_CROPCAP, &ratio) < 0)
> +			return 1.0;
> +
> +		return (double)ratio.pixelaspect.denominator / ratio.pixelaspect.numerator;
> +	}
> +	if (m_pixelAspectRatio->currentText().compare("NTSC/PAL-M/PAL-60") == 0)
> +		return 10.0/11.0;
> +	if (m_pixelAspectRatio->currentText().compare("NTSC/PAL-M/PAL-60, Anamorphic") == 0)
> +		return 40.0/33.0;
> +	if (m_pixelAspectRatio->currentText().compare("PAL/SECAM") == 0)
> +		return 12.0/11.0;
> +	if (m_pixelAspectRatio->currentText().compare("PAL/SECAM, Anamorphic") == 0)
> +		return 16.0/11.0;

These string compares are flaky: if someone changes the string in the GUI, then it is
all too easy to forget about changing this.

Take a look at how the audio mode (m_audioMode) is handled. You should do something
similar.

> +	return 1.0;
> +}
> +

Regards,

	Hans


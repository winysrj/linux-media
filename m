Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:49061 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab2JJO7C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 10:59:02 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com, linux-doc@vger.kernel.org
Subject: [PATCHv10 17/26] Documentation: media: description of DMABUF exporting
 in V4L2
Date: Wed, 10 Oct 2012 16:46:36 +0200
Message-id: <1349880405-26049-18-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds description and usage examples for exporting
DMABUF file descriptor in V4L2.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: linux-doc@vger.kernel.org
---
 Documentation/DocBook/media/v4l/compat.xml        |    3 +
 Documentation/DocBook/media/v4l/io.xml            |    3 +
 Documentation/DocBook/media/v4l/v4l2.xml          |    1 +
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml |  212 +++++++++++++++++++++
 4 files changed, 219 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-expbuf.xml

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 50eb630..3dd9e78 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2590,6 +2590,9 @@ ioctls.</para>
 	  <para>Importing DMABUF file descriptors as a new IO method described
 	  in <xref linkend="dmabuf" />.</para>
         </listitem>
+        <listitem>
+	  <para>Exporting DMABUF files using &VIDIOC-EXPBUF; ioctl.</para>
+        </listitem>
       </itemizedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 0abb5cb..81d0ed4 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -488,6 +488,9 @@ DMA buffer from userspace using a file descriptor previously exported for a
 different or the same device (known as the importer role), or both. This
 section describes the DMABUF importer role API in V4L2.</para>
 
+    <para>Refer to <link linked="vidioc-expbuf"> DMABUF exporting </link> for
+details about exporting V4L2 buffers as DMABUF file descriptors.</para>
+
 <para>Input and output devices support the streaming I/O method when the
 <constant>V4L2_CAP_STREAMING</constant> flag in the
 <structfield>capabilities</structfield> field of &v4l2-capability; returned by
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 10ccde9..4d110b1 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -543,6 +543,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-enuminput;
     &sub-enumoutput;
     &sub-enumstd;
+    &sub-expbuf;
     &sub-g-audio;
     &sub-g-audioout;
     &sub-g-crop;
diff --git a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
new file mode 100644
index 0000000..72dfbd2
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
@@ -0,0 +1,212 @@
+<refentry id="vidioc-expbuf">
+
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_EXPBUF</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_EXPBUF</refname>
+    <refpurpose>Export a buffer as a DMABUF file descriptor.</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_exportbuffer *<parameter>argp</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+
+    <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>VIDIOC_EXPBUF</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>argp</parameter></term>
+	<listitem>
+	  <para></para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <note>
+      <title>Experimental</title>
+      <para>This is an <link linkend="experimental"> experimental </link>
+      interface and may change in the future.</para>
+    </note>
+
+<para>This ioctl is an extension to the <link linkend="mmap">memory
+mapping</link> I/O method, therefore it is available only for
+<constant>V4L2_MEMORY_MMAP</constant> buffers.  It can be used to export a
+buffer as a DMABUF file at any time after buffers have been allocated with the
+&VIDIOC-REQBUFS; ioctl.</para>
+
+<para> To export a buffer, applications fill &v4l2-exportbuffer;.  The
+<structfield> type </structfield> field is set to the same buffer type as was
+previously used with  &v4l2-requestbuffers;<structfield> type </structfield>.
+Applications must also set the <structfield> index </structfield> field. Valid
+index numbers range from zero to the number of buffers allocated with
+&VIDIOC-REQBUFS; (&v4l2-requestbuffers;<structfield> count </structfield>)
+minus one.  For the multi-planar API, applications set the <structfield> plane
+</structfield> field to the index of the plane to be exported. Valid planes
+range from zero to the maximal number of valid planes for the currently active
+format. For the single-planar API, applications must set <structfield> plane
+</structfield> to zero.  Additional flags may be posted in the <structfield>
+flags </structfield> field.  Refer to a manual for open() for details.
+Currently only O_CLOEXEC is supported.  All other fields must be set to zero.
+In the case of multi-planar API, every plane is exported separately using
+multiple <constant> VIDIOC_EXPBUF </constant> calls. </para>
+
+<para> After calling <constant>VIDIOC_EXPBUF</constant> the <structfield> fd
+</structfield> field will be set by a driver.  This is a DMABUF file
+descriptor. The application may pass it to other DMABUF-aware devices. Refer to
+<link linkend="dmabuf">DMABUF importing</link> for details about importing
+DMABUF files into V4L2 nodes. It is recommended to close a DMABUF file when it
+is no longer used to allow the associated memory to be reclaimed. </para>
+
+  </refsect1>
+  <refsect1>
+   <section>
+      <title>Examples</title>
+
+      <example>
+	<title>Exporting a buffer.</title>
+	<programlisting>
+int buffer_export(int v4lfd, &v4l2-buf-type; bt, int index, int *dmafd)
+{
+	&v4l2-exportbuffer; expbuf;
+
+	memset(&amp;expbuf, 0, sizeof(expbuf));
+	expbuf.type = bt;
+	expbuf.index = index;
+	if (ioctl(v4lfd, &VIDIOC-EXPBUF;, &amp;expbuf) == -1) {
+		perror("VIDIOC_EXPBUF");
+		return -1;
+	}
+
+	*dmafd = expbuf.fd;
+
+	return 0;
+}
+        </programlisting>
+      </example>
+
+      <example>
+	<title>Exporting a buffer using the multi-planar API.</title>
+	<programlisting>
+int buffer_export_mp(int v4lfd, &v4l2-buf-type; bt, int index,
+	int dmafd[], int n_planes)
+{
+	int i;
+
+	for (i = 0; i &lt; n_planes; ++i) {
+		&v4l2-exportbuffer; expbuf;
+
+		memset(&amp;expbuf, 0, sizeof(expbuf));
+		expbuf.type = bt;
+		expbuf.index = index;
+		expbuf.plane = i;
+		if (ioctl(v4lfd, &VIDIOC-EXPBUF;, &amp;expbuf) == -1) {
+			perror("VIDIOC_EXPBUF");
+			while (i)
+				close(dmafd[--i]);
+			return -1;
+		}
+		dmafd[i] = expbuf.fd;
+	}
+
+	return 0;
+}
+        </programlisting>
+      </example>
+   </section>
+  </refsect1>
+
+  <refsect1>
+    <table pgwide="1" frame="none" id="v4l2-exportbuffer">
+      <title>struct <structname>v4l2_exportbuffer</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>type</structfield></entry>
+	    <entry>Type of the buffer, same as &v4l2-format;
+<structfield>type</structfield> or &v4l2-requestbuffers;
+<structfield>type</structfield>, set by the application. See <xref
+linkend="v4l2-buf-type" /></entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>index</structfield></entry>
+	    <entry>Number of the buffer, set by the application. This field is
+only used for <link linkend="mmap">memory mapping</link> I/O and can range from
+zero to the number of buffers allocated with the &VIDIOC-REQBUFS; and/or
+&VIDIOC-CREATE-BUFS; ioctls. </entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>plane</structfield></entry>
+	    <entry>Index of the plane to be exported when using the
+multi-planar API. Otherwise this value must be set to zero. </entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>Flags for the newly created file, currently only <constant>
+O_CLOEXEC </constant> is supported, refer to the manual of open() for more
+details.</entry>
+	  </row>
+	  <row>
+	    <entry>__s32</entry>
+	    <entry><structfield>fd</structfield></entry>
+	    <entry>The DMABUF file descriptor associated with a buffer. Set by
+		the driver.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved[11]</structfield></entry>
+	    <entry>Reserved field for future use. Must be set to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EINVAL</errorcode></term>
+	<listitem>
+	  <para>A queue is not in MMAP mode or DMABUF exporting is not
+supported or <structfield> flags </structfield> or <structfield> type
+</structfield> or <structfield> index </structfield> or <structfield> plane
+</structfield> fields are invalid.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+</refentry>
-- 
1.7.9.5


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21916 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab2FNOcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 10:32:41 -0400
Date: Thu, 14 Jun 2012 16:32:22 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 2/9] Documentation: media: description of DMABUF exporting in
 V4L2
In-reply-to: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de,
	linux-doc@vger.kernel.org
Message-id: <1339684349-28882-3-git-send-email-t.stanislaws@samsung.com>
Content-transfer-encoding: 7BIT
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
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
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml |  223 +++++++++++++++++++++
 4 files changed, 230 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-expbuf.xml

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 07a311f..7773450 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2591,6 +2591,9 @@ ioctls.</para>
 	  <para>Importing DMABUF file descriptors as a new IO method described
 	  in <xref linkend="dmabuf" />.</para>
         </listitem>
+        <listitem>
+	  <para>Exporting DMABUF files using &VIDIOC-EXPBUF; ioctl.</para>
+        </listitem>
       </itemizedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index f55b0ab..7a0dfc9 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -488,6 +488,9 @@ buffer from userspace using a file descriptor previously exported for a
 different or the same device (known as the importer role), or both. This
 section describes the DMABUF importer role API in V4L2.</para>
 
+    <para>Refer to <link linked="vidioc-expbuf"> DMABUF exporting </link> for
+details about exporting a V4L2 buffers as DMABUF file descriptors.</para>
+
 <para>Input and output devices support the streaming I/O method when the
 <constant>V4L2_CAP_STREAMING</constant> flag in the
 <structfield>capabilities</structfield> field of &v4l2-capability; returned by
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 015c561..8f650d2 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -561,6 +561,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-log-status;
     &sub-overlay;
     &sub-qbuf;
+    &sub-expbuf;
     &sub-querybuf;
     &sub-querycap;
     &sub-queryctrl;
diff --git a/Documentation/DocBook/media/v4l/vidioc-expbuf.xml b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
new file mode 100644
index 0000000..30ebf67
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-expbuf.xml
@@ -0,0 +1,223 @@
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
+mapping</link> I/O method therefore it is available only for
+<constant>V4L2_MEMORY_MMAP</constant> buffers.  It can be used to export a
+buffer as DMABUF file at any time after buffers have been allocated with the
+&VIDIOC-REQBUFS; ioctl.</para>
+
+<para>Prior to exporting an application calls <link
+linkend="vidioc-querybuf">VIDIOC_QUERYBUF</link> to obtain memory offsets. When
+using the <link linkend="planar-apis">multi-planar API</link> every plane has
+own offset.</para>
+
+<para>To export a buffer, the application fills &v4l2-exportbuffer;.  The
+<structfield> mem_offset </structfield> field is set to the offset obtained
+from <constant> VIDIOC_QUERYBUF </constant>.  Additional flags may be posted in
+the <structfield> flags </structfield> field.  Refer to manual for open syscall
+for details. Currently only O_CLOEXEC is guaranteed to be supported.  All other
+fields must be set to zero.  In a case of multi-planar API, every plane is
+exported separately using multiple <constant> VIDIOC_EXPBUF </constant>
+calls.</para>
+
+<para> After calling <constant>VIDIOC_EXPBUF</constant> the <structfield> fd
+</structfield> field will be set by a driver.  This is a DMABUF file
+descriptor. The application may pass it to other API. Refer to <link
+linkend="dmabuf">DMABUF importing</link> for details about importing DMABUF
+files into V4L2 nodes. A developer is encouraged to close a DMABUF file when it
+is no longer used.  </para>
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
+	&v4l2-buffer; buf;
+	&v4l2-exportbuffer; expbuf;
+
+	memset(&amp;buf, 0, sizeof buf);
+	buf.type = bt;
+	buf.memory = V4L2_MEMORY_MMAP;
+	buf.index = index;
+
+	if (ioctl (v4lfd, &VIDIOC-QUERYBUF;, &amp;buf) == -1) {
+		perror ("VIDIOC_QUERYBUF");
+		return -1;
+	}
+
+	memset(&amp;expbuf, 0, sizeof expbuf);
+	expbuf.mem_offset = buf.m.offset;
+	if (ioctl (v4lfd, &VIDIOC-EXPBUF;, &amp;expbuf) == -1) {
+		perror ("VIDIOC_EXPBUF");
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
+	<title>Exporting a buffer using multi plane API.</title>
+	<programlisting>
+int buffer_export_mp(int v4lfd, &v4l2-buf-type; bt, int index,
+	int dmafd[], int n_planes)
+{
+	&v4l2-buffer; buf;
+	&v4l2-plane; planes[VIDEO_MAX_PLANES];
+	int i;
+
+	memset(&amp;buf, 0, sizeof buf);
+	buf.type = bt;
+	buf.memory = V4L2_MEMORY_MMAP;
+	buf.index = index;
+	buf.m.planes = planes;
+	buf.length = n_planes;
+	memset(&amp;planes, 0, sizeof planes);
+
+	if (ioctl (v4lfd, &VIDIOC-QUERYBUF;, &amp;buf) == -1) {
+		perror ("VIDIOC_QUERYBUF");
+		return -1;
+	}
+
+	for (i = 0; i &lt; n_planes; ++i) {
+		&v4l2-exportbuffer; expbuf;
+
+		memset(&amp;expbuf, 0, sizeof expbuf);
+		expbuf.mem_offset = plane[i].m.offset;
+		if (ioctl (v4lfd, &VIDIOC-EXPBUF;, &amp;expbuf) == -1) {
+			perror ("VIDIOC_EXPBUF");
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
+	    <entry><structfield>fd</structfield></entry>
+	    <entry>The DMABUF file descriptor associated with a buffer. Set by
+		a driver.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved0</structfield></entry>
+	    <entry>Reserved field for future use. Must be set to zero.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>mem_offset</structfield></entry>
+	    <entry>Buffer memory offset as returned by <constant>
+VIDIOC_QUERYBUF </constant> in &v4l2-buffer;<structfield> ::m.offset
+</structfield> (for single-plane formats) or &v4l2-plane;<structfield>
+::m.offset </structfield> (for multi-planar formats)</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>Flags for newly created file, currently only <constant>
+O_CLOEXEC </constant> is supported, refer to manual of open syscall for more
+details.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved[12]</structfield></entry>
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
+supported or <structfield> flag </structfield> or <structfield> mem_offset
+</structfield> fields are invalid.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+</refentry>
-- 
1.7.9.5

